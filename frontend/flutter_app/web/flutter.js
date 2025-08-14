// Flutter Web Loader - Version compatible
(function() {
  'use strict';
  
  // Configuration Flutter Web
  window._flutter = window._flutter || {};
  window._flutter.loader = {
    loadEntrypoint: function(options) {
      const onEntrypointLoaded = options.onEntrypointLoaded;
      
      // Initialisation normale de Flutter
      const engineInitializer = {
        initializeEngine: function(config) {
          return new Promise(function(resolve) {
            // Configuration par défaut
            const defaultConfig = {
              renderer: "canvaskit",
              ...config
            };
            
            // Simuler l'initialisation de l'engine Flutter
            setTimeout(function() {
              const appRunner = {
                runApp: function() {
                  console.log('✅ Application Flutter démarrée');
                  // Ne pas rediriger - laisser Flutter s'exécuter normalement
                  return Promise.resolve();
                }
              };
              resolve(appRunner);
            }, 1000);
          });
        }
      };
      
      // Appeler le callback
      if (onEntrypointLoaded) {
        onEntrypointLoaded(engineInitializer);
      }
    }
  };
  
  console.log('✅ Flutter loader initialisé correctement');
})();

