/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Override default xpra function to add keyboard lock request.
window.toggle_fullscreen = function () {
    const f_el = document.hasOwnProperty("requestFullScreen") || document.hasOwnProperty("webkitRequestFullScreen") || document.hasOwnProperty("mozRequestFullScreen") || document.hasOwnProperty("msRequestFullscreen");
    if (!f_el) {
        const elem = document.getElementById("fullscreen_button");
        const req = elem.requestFullScreen || elem.webkitRequestFullScreen || elem.mozRequestFullScreen || elem.msRequestFullscreen;
        if (req) {
            req.call(document.body);

            // event codes: https://www.w3.org/TR/uievents-code/#key-alphanumeric-writing-system
            const keys = [
                "AltLeft",
                "AltRight",
                "Tab",
                "Escape",
                "ContextMenu",
                "MetaLeft",
                "MetaRight"
            ];
            navigator.keyboard.lock(keys).then(
                () => {
                    console.log("keyboard lock success");
                }
            ).catch(
                (e) => {
                    console.log("keyboard lock failed: ", e);
                }
            )
        }

        $('#fullscreen').attr('src', './icons/unfullscreen.png');
        $('#fullscreen_button').attr('data-icon', 'fullscreen_exit');

    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.webkitExitFullscreen) {
            document.webkitExitFullscreen();
        } else if (document.hasOwnProperty("mozCancelFullScreen")) {
            document.mozCancelFullScreen();
        } else if (document.hasOwnProperty("msExitFullscreen")) {
            document.msExitFullscreen();
        }
    }
}

// If floating menu is hidden, the fullscreen button is not visible, add hotkey CTRL+SHIFT+F to enter fullscreen mode.
window.addEventListener('keydown', (event) => {
    // capture fullscreen hotkey
    if (event.type === 'keydown' && event.code === 'KeyF' && event.ctrlKey && event.shiftKey) {
        if (document.fullscreenElement === null && this.onfullscreenhotkey !== null) {
            window.toggle_fullscreen();
        }
        return;
    }
});

