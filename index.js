const spotlight = require('bindings')('Spotlight.node');
const noop = () => {};

module.exports = function addItem(id = '', title = '', callback = noop) {
  if (process.platform !== 'darwin') {
    throw new Error('Only supported on macOS');
  }

  return spotlight.addItem(id, title, callback);
}
