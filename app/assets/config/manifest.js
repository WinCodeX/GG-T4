//= link_tree ../images
//= link_directory ../stylesheets .css
//= link_tree ../../javascript .js
//= link_tree ../../../vendor/javascript .js
//= link_tree ../builds
// If using js bundling (esbuild/webpack):
import "../stylesheets/application.tailwind.css"
// tailwind.config.js
module.exports = {
    theme: {
      extend: {
        colors: {
          dracula: {
            background: '#282A36',
            surface:    '#44475A',
            foreground: '#F8F8F2',
            comment:    '#6272A4',
            cyan:       '#8BE9FD',
            green:      '#50FA7B',
            orange:     '#FFB86C',
            pink:       '#FF79C6',
            purple:     '#BD93F9',
          },
        },
        // create a purple gradient for outlines
        backgroundImage: {
          'purple-gradient': 'linear-gradient(135deg, #BD93F9 0%, #8BE9FD 100%)',
        },
      }
    }
  }
  