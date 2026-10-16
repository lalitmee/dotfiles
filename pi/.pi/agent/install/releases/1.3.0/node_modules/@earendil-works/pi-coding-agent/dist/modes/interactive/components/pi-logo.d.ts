/**
 * The pi logo: 4 cells wide and 2 lines tall. Each cell shows two square pixels with half blocks:
 *
 *   coral coral coral .
 *   blue  .     coral .
 *   blue  blue  .     yellow
 *   blue  .     .     yellow
 *
 * The brand colors stay fixed across themes; they follow the terminal's color mode.
 */
export declare function piLogoLines(): [string, string];
/**
 * Whether the terminal renders the half-block logo correctly. Apple Terminal draws gaps between rows and
 * misaligns the half blocks, so it gets the text wordmark instead.
 */
export declare function supportsPiLogo(): boolean;
/** Text fallback for the logo: "Pi" with the logo's coral and yellow. */
export declare function piWordmark(): string;
//# sourceMappingURL=pi-logo.d.ts.map