const webpack = require('webpack');
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

const srcPath = path.join(__dirname, '../../src');
const outPath = path.join(__dirname, '../../docs');

module.exports = {
  __srcPath__: srcPath,
  __outPath__: outPath,

  publicPath: '/',

  module: {
    loaders: [{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      loader: 'elm-webpack'
    }, {
      test: /\.ttf|.svg|.woff|.eot/,
      loaders: ['file'],
    }],
  },

  entry: {
    main: path.join(srcPath, '/index.js'),
  },

  output: {
    path: outPath,
    filename: '[name].js',
    publicPath: '/',
  },

  resolve: {},

  plugins: [
    new HtmlWebpackPlugin({
      template: path.join(srcPath, 'index.html'),
      filename: 'index.html',
      inject: 'body',
      chunks: ['main'],
    }),
  ],

  postcss: function() {
    return [autoprefixer];
  },

  externals: [],
};
