exports.config =

  paths:
    public: 'public'

  files:
    javascripts:
      defaultExtension: 'coffee'

      joinTo:
        'js/game.js': /^app/
        'js/vendor.js': /^bower_components/

    stylesheets:
      defaltExtension: 'sass'

      joinTo:
        'css/vendor.css': /^bower_components/
        'css/styles.css': /^app/

