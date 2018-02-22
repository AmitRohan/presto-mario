function openInNewTab(url) {
  var win = window.open(url, '_blank');
  win.focus();
}

exports["openUrl"]  = function(a) {
  return function() {
    console.log(a);
    openInNewTab(a);
  }
}