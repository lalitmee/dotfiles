import sys
import re


def filter_bangs(file_path, verbose=False):
    """
    Filters lines from a file, keeping only those whose bang descriptions
    are primarily in English or Hindi, and do not contain specific
    non-English/non-Hindi country code indicators.

    Returns the filtered lines as a string and a stats dictionary.
    """
    filtered_lines = []
    total = kept = filtered_lang = filtered_country = filtered_other_script = 0

    NON_ENGLISH_ACCENTED_CHARS_PATTERN = re.compile(
        r"[áÁàÀâÂäÄãÃåÅæÆčČçÇćĆďĎđĐéÉèÈêÊëËěĚğĞíÍìÌîÎïÏľĽĺĹłŁňŇńŃóÓòÒôÔöÖõÕőŐøØœŒřŘŕŔšŠśŚťŤţŢúÚùÙûÛüÜűŰůŮýÝÿŸžŽźŹżŻ]"
    )
    DEVANAGARI_PATTERN = re.compile(r"[\u0900-\u097F]")

    all_iso_codes_raw = """AD, AE, AF, AG, AI, AL, AM, AO, AQ, AR, AS, AT, AW, AX, AZ, BA, BB, BD, BE, BF, BG, BH, BI, BJ, BL, BM, BN, BO, BQ, BR, BS, BT, BV, BW, BY, BZ, CA, CC, CD, CF, CG, CH, CI, CK, CL, CM, CN, CO, CR, CU, CV, CW, CX, CY, CZ, DE, DJ, DK, DM, DO, DZ, EC, EE, EG, EH, ER, ES, ET, FI, FJ, FK, FM, FO, FR, GA, GB, GD, GE, GF, GG, GH, GI, GL, GM, GN, GP, GQ, GR, GS, GT, GU, GW, GY, HK, HM, HN, HR, HT, HU, ID, IE, IL, IM, IN, IO, IQ, IR, IS, IT, JE, JM, JO, JP, KE, KG, KH, KI, KM, KN, KP, KR, KW, KY, KZ, LA, LC, LI, LK, LR, LS, LT, LU, LV, LY, MA, MC, MD, ME, MF, MG, MH, MK, ML, MM, MN, MO, MP, MQ, MR, MS, MT, MU, MV, MW, MX, MY, MZ, NA, NC, NE, NF, NG, NI, NL, NO, NP, NR, NU, OM, PA, PE, PF, PG, PH, PK, PL, PM, PN, PR, PS, PT, PW, PY, QA, RE, RO, RS, RU, RW, SA, SB, SC, SD, SE, SG, SH, SI, SJ, SK, SL, SM, SN, SO, SR, SS, ST, SV, SX, SY, SZ, TC, TD, TF, TG, TH, TJ, TK, TL, TM, TN, TO, TR, TT, TV, TW, TZ, UA, UG, UM, US, UY, UZ, VA, VC, VE, VG, VI, VN, VU, WF, WS, YE, YT, ZA, ZM, ZW"""
    all_iso_codes = set(code.strip().lower() for code in all_iso_codes_raw.split(","))
    allowed_iso_codes_to_keep = {
        "us",
        "uk",
        "in",
        "ca",
        "au",
        "nz",
        "ie",
        "jm",
        "bs",
        "tt",
        "gd",
        "bb",
        "lc",
        "dm",
        "vc",
        "ag",
        "pk",
        "bd",
        "sg",
        "hk",
    }
    forbidden_iso_codes = all_iso_codes - allowed_iso_codes_to_keep

    forbidden_lang_pair_patterns = set()
    for code in forbidden_iso_codes:
        if len(code) == 2:
            forbidden_lang_pair_patterns.add(f"{code}en")
            forbidden_lang_pair_patterns.add(f"{code}-en")
            forbidden_lang_pair_patterns.add(f"en-{code}")
            forbidden_lang_pair_patterns.add(code)
            forbidden_lang_pair_patterns.add(f"reverso{code}")
            forbidden_lang_pair_patterns.add(f"pons{code}")
            forbidden_lang_pair_patterns.add(f"gt{code}")
            forbidden_lang_pair_patterns.add(f"wikt{code}")

    try:
        with open(file_path, "r", encoding="utf-8") as f:
            for lineno, line in enumerate(f, 1):
                total += 1
                clean_line = line.strip()
                if not clean_line:
                    filtered_lines.append(clean_line)
                    continue

                parts = clean_line.split("\t", 1)
                if len(parts) < 2:
                    filtered_lines.append(clean_line)
                    continue

                keyword = parts[0].strip()
                description_raw = parts[1]
                description_content = (
                    description_raw[1:].strip()
                    if description_raw.startswith("!")
                    else description_raw.strip()
                )

                keyword_lower = keyword.lower()
                description_lower = description_content.lower()

                is_english_like_desc = not bool(
                    NON_ENGLISH_ACCENTED_CHARS_PATTERN.search(description_content)
                )
                is_hindi_like_desc = bool(
                    DEVANAGARI_PATTERN.search(description_content)
                )

                is_other_script_present = False
                for char in description_content:
                    char_ord = ord(char)
                    if not (
                        0x0000 <= char_ord <= 0x007F
                        or 0x0900 <= char_ord <= 0x097F
                        or char.isspace()
                        or char.isdigit()
                        or not char.isalpha()
                    ):
                        if char not in "«»“”‘’—–-—…‘’‚„":
                            is_other_script_present = True
                            break

                # Feedback for script check
                if is_other_script_present and not is_hindi_like_desc:
                    filtered_other_script += 1
                    if verbose:
                        print(f"[Line {lineno}] FILTERED (other script): {clean_line}")
                    continue

                if not is_hindi_like_desc and not is_english_like_desc:
                    filtered_lang += 1
                    if verbose:
                        print(
                            f"[Line {lineno}] FILTERED (not English/Hindi): {clean_line}"
                        )
                    continue

                has_forbidden_country_indicator = False
                for code in forbidden_iso_codes:
                    if keyword_lower == code:
                        has_forbidden_country_indicator = True
                        break
                    if (
                        keyword_lower.endswith(code)
                        and len(keyword_lower) > len(code)
                        and (
                            keyword_lower[: -len(code)][-1].isalpha()
                            or keyword_lower[: -len(code)][-1].isdigit()
                        )
                    ):
                        if not re.search(
                            r"\b" + re.escape(code) + r"\b", keyword_lower
                        ):
                            has_forbidden_country_indicator = True
                            break
                    if re.search(
                        r"\." + re.escape(code) + r"(?=\b|$|/)", description_lower
                    ):
                        has_forbidden_country_indicator = True
                        break
                    if re.search(
                        r"[\(\[]" + re.escape(code) + r"[\)\]]", description_lower
                    ):
                        has_forbidden_country_indicator = True
                        break

                for pattern in forbidden_lang_pair_patterns:
                    # REMOVE word boundaries so patterns like 'ponsde' match
                    if pattern in keyword_lower or pattern in description_lower:
                        has_forbidden_country_indicator = True
                        break

                if has_forbidden_country_indicator:
                    filtered_country += 1
                    if verbose:
                        print(f"[Line {lineno}] FILTERED (country): {clean_line}")
                    continue

                filtered_lines.append(clean_line)
                kept += 1
                if verbose:
                    print(f"[Line {lineno}] KEPT: {clean_line}")

    except FileNotFoundError:
        print(f"Error: File not found at {file_path}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred: {e}", file=sys.stderr)
        sys.exit(1)

    stats = {
        "total_lines": total,
        "kept": kept,
        "filtered_lang": filtered_lang,
        "filtered_country": filtered_country,
        "filtered_other_script": filtered_other_script,
        "blank": total
        - (kept + filtered_lang + filtered_country + filtered_other_script),
    }
    return "\n".join(filtered_lines), stats


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Filter bang lines for English/Hindi.")
    parser.add_argument("file", help="Input file path")
    parser.add_argument(
        "-v", "--verbose", action="store_true", help="Show filtering feedback."
    )
    args = parser.parse_args()

    filtered, stats = filter_bangs(args.file, args.verbose)
    print(filtered)
    print("\n--- Summary ---")
    print(f"Lines read: {stats['total_lines']}")
    print(f"Lines kept: {stats['kept']}")
    print(f"Filtered by language: {stats['filtered_lang']}")
    print(f"Filtered by country: {stats['filtered_country']}")
    print(f"Filtered by script: {stats['filtered_other_script']}")
    print(f"Blank/other: {stats['blank']}")
