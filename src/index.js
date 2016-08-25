require('normalize.css');
require('weather-icons/css/weather-icons.min.css');
require('./App/style.css');
require('./Widget/style.css');
require('./Widget/Clock/style.css');
require('./Widget/Weather/style.css');

require('./Main.elm')
.Main
.embed(
  document.getElementById('Root')
);
