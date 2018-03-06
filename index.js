const spotlight = require('bindings')('Spotlight.node');

module.exports = function addItem(id = '', title = '') {
  if (process.platform !== 'darwin') {
    throw new Error('Only supported on macOS');
  }

  return spotlight.addItem(id, title);
}
