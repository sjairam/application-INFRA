//this is a junk file but an example of something you might want mounted -- no secrets!!
(function (window) {

    // Initialize window object
    window.__env = window.__env || {};

    // API url
    window.__env.apiUrl = `https://application.lib.harvard.edu/api`;

    // Client base url
    window.__env.clientBaseUrl = `https://application.lib.harvard.edu`;

    // Setting this to false will disable console output
    window.__env.enableDebug = true;

  }(this));
