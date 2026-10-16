/** Returns the number of grapheme clusters in a string */
export declare function GraphemeCount(value: string): number;
/** Fast check for minimum grapheme length, falls back to full check if needed */
export declare function IsMinLength(value: string, minLength: number): boolean;
/** Fast check for maximum grapheme length, falls back to full check if needed */
export declare function IsMaxLength(value: string, maxLength: number): boolean;
