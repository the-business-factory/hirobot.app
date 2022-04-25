import * as Turbo from "@hotwired/turbo"
import { Application } from "@hotwired/stimulus"

import RemovableController from "./controllers/removable_controller";
import ToggleController from "./controllers/toggle_controller";

require("@rails/ujs").start();

declare global {
  interface Window {
    Stimulus: any;
  }
}

let Stimulus = (window.Stimulus = Application.start());
Stimulus.register("toggle", ToggleController);
Stimulus.register("removable", RemovableController);
