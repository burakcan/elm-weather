const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const baseConfig = require('./webpack.config.base');

const extractCSS = new ExtractTextPlugin(
  '[hash].css',
  { allChunks: true }
);

module.exports = Object.assign(baseConfig, {
  debug: false,
  devtool: false,

  module: Object.assign(baseConfig.module, {
    loaders: baseConfig.module.loaders.concat([{
      test: /\.css/,
      loader: extractCSS.extract(['css']),
    }]),
  }),

  plugins: baseConfig.plugins.concat([
    extractCSS,
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
        dead_code: true,
        drop_debugger: true,
        conditionals: true,
        unsafe: true,
        evaluate: true,
        booleans: true,
        loops: true,
        unused: true,
        if_return: true,
        join_vars: true,
        cascade: true,
        collapse_vars: true,
        negate_iife: true,
        pure_getters: true,
        drop_console: true,
        keep_fargs: false,
      },
      'screw-ie8': true,
      mangle: true,
      stats: true,
    }),
  ]),
});
