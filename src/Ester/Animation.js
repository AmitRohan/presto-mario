exports["logAny"]  = function(a) {
  console.log(a);
}

exports.getById = function(id) {
  id= id.value0;
  return document.getElementById(id);   
}

exports.transform = function(mode) {
  return function (value) {
    return function(svgObj) {
        value= value.value0;
        svgObj.setAttribute("transform", mode+"("+value+")");
        return svgObj
      }
  }
}

exports.rotateAt = function(value) {
  return function (cx) {
    return function (cy) {
      return function(interval) {
        return function(svgObj) {
          value= value.value0;
          interval= interval.value0;
          svgObj.setAttribute("transform", "rotate("+value+", "+cx+", "+cy+")");
          return svgObj
        }
      }
    }
  }
}
