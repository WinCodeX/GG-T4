// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import SubmitOnEnterController from "./controllers/submit_on_enter_controller"
application.register("submit-on-enter", SubmitOnEnterController)