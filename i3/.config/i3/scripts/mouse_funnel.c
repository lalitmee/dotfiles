/*
 * mouse_funnel.c - Smooth mouse cursor transitions across mismatched monitor boundaries.
 *
 * Intercepts XInput2 raw motion events when the mouse is at a dead screen border
 * (where no adjacent monitor exists at that coordinate) and smoothly warps the cursor
 * to the nearest boundary of the adjacent display.
 *
 * In overlapping screen regions, standard X11 transitions remain untouched (1:1 direct).
 *
 * Compile:
 *   gcc -O2 -o mouse_funnel mouse_funnel.c -lX11 -lXi -lXrandr
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <X11/Xlib.h>
#include <X11/extensions/XInput2.h>
#include <X11/extensions/Xrandr.h>

#define EDGE_THRESHOLD 2 // Pixels from edge to trigger warp

typedef struct {
    char name[32];
    int x, y, w, h;
    int index;
} Monitor;

static Monitor *monitors = NULL;
static int monitor_count = 0;
static Display *dpy = NULL;
static Window root;
static int rr_event_base, rr_error_base;
static int debug_mode = 0;

void update_monitors(void) {
    XRRScreenResources *res = XRRGetScreenResourcesCurrent(dpy, root);
    if (!res) return;

    if (monitors) {
        free(monitors);
        monitors = NULL;
    }
    monitor_count = 0;

    for (int i = 0; i < res->noutput; i++) {
        XRROutputInfo *info = XRRGetOutputInfo(dpy, res, res->outputs[i]);
        if (info->crtc && info->connection == RR_Connected) {
            monitor_count++;
        }
        XRRFreeOutputInfo(info);
    }

    if (monitor_count > 0) {
        monitors = malloc(sizeof(Monitor) * monitor_count);
        int valid_idx = 0;

        for (int i = 0; i < res->noutput; i++) {
            XRROutputInfo *info = XRRGetOutputInfo(dpy, res, res->outputs[i]);
            if (info->crtc && info->connection == RR_Connected) {
                XRRCrtcInfo *crtc = XRRGetCrtcInfo(dpy, res, info->crtc);
                strncpy(monitors[valid_idx].name, info->name, sizeof(monitors[valid_idx].name) - 1);
                monitors[valid_idx].name[sizeof(monitors[valid_idx].name) - 1] = '\0';
                monitors[valid_idx].x = crtc->x;
                monitors[valid_idx].y = crtc->y;
                monitors[valid_idx].w = crtc->width;
                monitors[valid_idx].h = crtc->height;
                monitors[valid_idx].index = valid_idx;
                if (debug_mode) {
                    fprintf(stderr, "[mouse_funnel] Monitor %d (%s): %dx%d at +%d+%d\n",
                            valid_idx, monitors[valid_idx].name,
                            monitors[valid_idx].w, monitors[valid_idx].h,
                            monitors[valid_idx].x, monitors[valid_idx].y);
                }
                valid_idx++;
                XRRFreeCrtcInfo(crtc);
            }
            XRRFreeOutputInfo(info);
        }
    }
    XRRFreeScreenResources(res);
    if (debug_mode) {
        fprintf(stderr, "[mouse_funnel] Layout updated: %d active monitors.\n", monitor_count);
    }
}

Monitor* get_monitor_at(int x, int y) {
    for (int i = 0; i < monitor_count; i++) {
        if (x >= monitors[i].x && x < monitors[i].x + monitors[i].w &&
            y >= monitors[i].y && y < monitors[i].y + monitors[i].h) {
            return &monitors[i];
        }
    }
    return NULL;
}

Monitor* get_target_monitor(Monitor *current, int dx, int dy) {
    Monitor *best = NULL;
    int best_dist = 2147483647;
    int cx = current->x + current->w / 2;
    int cy = current->y + current->h / 2;

    for (int i = 0; i < monitor_count; i++) {
        if (&monitors[i] == current) continue;

        Monitor *m = &monitors[i];
        int is_candidate = 0;

        if (dx < 0 && m->x + m->w <= current->x) is_candidate = 1;            // Left
        else if (dx > 0 && m->x >= current->x + current->w) is_candidate = 1; // Right
        else if (dy < 0 && m->y + m->h <= current->y) is_candidate = 1;       // Up
        else if (dy > 0 && m->y >= current->y + current->h) is_candidate = 1; // Down

        if (is_candidate) {
            int mx = m->x + m->w / 2;
            int my = m->y + m->h / 2;
            int dist = (cx - mx) * (cx - mx) + (cy - my) * (cy - my);
            if (dist < best_dist) {
                best_dist = dist;
                best = m;
            }
        }
    }
    return best;
}

static inline int clamp(int val, int min, int max) {
    if (val < min) return min;
    if (val > max) return max;
    return val;
}

int main(int argc, char **argv) {
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--debug") == 0 || strcmp(argv[i], "-d") == 0) {
            debug_mode = 1;
        }
    }

    dpy = XOpenDisplay(NULL);
    if (!dpy) {
        fprintf(stderr, "[mouse_funnel] Failed to open X display.\n");
        return 1;
    }
    root = DefaultRootWindow(dpy);

    int xi_opcode, event, error;
    if (!XQueryExtension(dpy, "XInputExtension", &xi_opcode, &event, &error)) {
        fprintf(stderr, "[mouse_funnel] XInput extension not available.\n");
        return 1;
    }

    if (!XRRQueryExtension(dpy, &rr_event_base, &rr_error_base)) {
        fprintf(stderr, "[mouse_funnel] RandR extension not available.\n");
        return 1;
    }

    // Select XInput2 RawMotion events
    XIEventMask mask;
    mask.deviceid = XIAllMasterDevices;
    int mask_len = XIMaskLen(XI_RawMotion);
    mask.mask_len = mask_len;
    unsigned char *mask_bits = calloc(mask_len, sizeof(unsigned char));
    XISetMask(mask_bits, XI_RawMotion);
    mask.mask = mask_bits;
    XISelectEvents(dpy, root, &mask, 1);
    free(mask_bits);

    // Select RandR Screen Change events
    XRRSelectInput(dpy, root, RRScreenChangeNotifyMask);
    update_monitors();

    if (debug_mode) {
        fprintf(stderr, "[mouse_funnel] Daemon started in debug mode.\n");
    }

    XEvent ev;
    while (1) {
        XNextEvent(dpy, &ev);

        if (ev.type == rr_event_base + RRScreenChangeNotify) {
            XRRUpdateConfiguration(&ev);
            update_monitors();
            continue;
        }

        if (ev.xcookie.type == GenericEvent && ev.xcookie.extension == xi_opcode && XGetEventData(dpy, &ev.xcookie)) {
            if (ev.xcookie.evtype == XI_RawMotion) {
                XIRawEvent *raw = (XIRawEvent*)ev.xcookie.data;
                double dx = 0.0, dy = 0.0;
                double *val_ptr = raw->raw_values;

                for (int i = 0; i < raw->valuators.mask_len * 8; i++) {
                    if (XIMaskIsSet(raw->valuators.mask, i)) {
                        if (i == 0) dx = *val_ptr;
                        else if (i == 1) dy = *val_ptr;
                        val_ptr++;
                    }
                }

                if (dx != 0.0 || dy != 0.0) {
                    Window root_ret, child_ret;
                    int root_x, root_y, win_x, win_y;
                    unsigned int mask_ret;
                    XQueryPointer(dpy, root, &root_ret, &child_ret, &root_x, &root_y, &win_x, &win_y, &mask_ret);

                    Monitor *curr = get_monitor_at(root_x, root_y);
                    if (curr) {
                        Monitor *target = NULL;
                        int new_x = root_x, new_y = root_y;
                        int warp = 0;

                        // Pushing Right at right border
                        if (dx > 0.1 && root_x >= curr->x + curr->w - 1 - EDGE_THRESHOLD) {
                            // Check if a monitor already exists immediately to the right at this Y
                            if (!get_monitor_at(curr->x + curr->w + 1, root_y)) {
                                target = get_target_monitor(curr, 1, 0);
                                if (target) {
                                    new_x = target->x + 2;
                                    new_y = clamp(root_y, target->y + 2, target->y + target->h - 3);
                                    warp = 1;
                                }
                            }
                        }
                        // Pushing Left at left border
                        else if (dx < -0.1 && root_x <= curr->x + EDGE_THRESHOLD) {
                            if (!get_monitor_at(curr->x - 1, root_y)) {
                                target = get_target_monitor(curr, -1, 0);
                                if (target) {
                                    new_x = target->x + target->w - 3;
                                    new_y = clamp(root_y, target->y + 2, target->y + target->h - 3);
                                    warp = 1;
                                }
                            }
                        }
                        // Pushing Down at bottom border
                        else if (dy > 0.1 && root_y >= curr->y + curr->h - 1 - EDGE_THRESHOLD) {
                            if (!get_monitor_at(root_x, curr->y + curr->h + 1)) {
                                target = get_target_monitor(curr, 0, 1);
                                if (target) {
                                    new_y = target->y + 2;
                                    new_x = clamp(root_x, target->x + 2, target->x + target->w - 3);
                                    warp = 1;
                                }
                            }
                        }
                        // Pushing Up at top border
                        else if (dy < -0.1 && root_y <= curr->y + EDGE_THRESHOLD) {
                            if (!get_monitor_at(root_x, curr->y - 1)) {
                                target = get_target_monitor(curr, 0, -1);
                                if (target) {
                                    new_y = target->y + target->h - 3;
                                    new_x = clamp(root_x, target->x + 2, target->x + target->w - 3);
                                    warp = 1;
                                }
                            }
                        }

                        if (warp && target) {
                            if (debug_mode) {
                                fprintf(stderr, "[mouse_funnel] Warping from (%d, %d) on [%s] -> (%d, %d) on [%s]\n",
                                        root_x, root_y, curr->name, new_x, new_y, target->name);
                            }
                            XWarpPointer(dpy, None, root, 0, 0, 0, 0, new_x, new_y);
                            XFlush(dpy);
                        }
                    }
                }
            }
            XFreeEventData(dpy, &ev.xcookie);
        }
    }

    XCloseDisplay(dpy);
    return 0;
}
