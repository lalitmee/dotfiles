/**
 * @license MIT
 *
 * This contains the type declarations for the xterm-addon-ligatures library.
 * Note that some interfaces may differ between this file and the actual
 * implementation in src/, that's because this file declares the *public* API
 * which is intended to be stable and consumed by external programs.
 */

declare module 'xterm-addon-ligatures' {
  import { Terminal } from 'xterm';

  /**
   * Add capabilities to the provided terminal class for enabling ligature
   * support. After calling this function, an `enableLigatures()` method is
   * available on the terminal class, which will enable ligature support when
   * called.
   * @param terminalConstructor Terminal class from xterm.js
   */
  export function apply(terminalConstructor: typeof Terminal): void;

  /**
   * Enable ligature support for the provided Terminal instance. To function
   * properly, this must be called after `open()` is called on the therminal. If
   * the font currently in use supports ligatures, the terminal will
   * automatically start to render them.
   * @param term Terminal instance from xterm.js
   */
  export function enableLigatures(term: Terminal): void;
}
