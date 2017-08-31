// Make sure to run `bin/pack` after changing this file.
// Or keep `bin/webpack-dev-server` running.
// Otherwise, the changes are not picked up by the asset pipeline.

import Vue from 'vue'
import TurbolinksAdapter from 'vue-turbolinks'


window.addEventListener('turbolinks:load', function() {

  let vueApp = new Vue({
    el: '#vue-app'
  })
})

