exports["logAny"]  = function(a) {
  console.log(a);
}

exports.getById = function(id) {
  id= id.value0;
  return document.getElementById(id);   
}

exports.transform = function(mode) {
  return function (value1) {
    return function(value2) {
      return function(svgObj) {
        value1= value1.value0;
        value2= value2.value0;
        // console.log(mode)
        mode= mode.value0;
        svgObj.setAttribute("transform", mode+"("+value1+","+value2+")");
        return svgObj
      }
    }
  }
}

exports.rotateAt = function(value) {
  return function (cx) {
    return function (cy) {
      return function(interval) {
        return function(svgObj) {
          value= value.value0;
          cx= cx.value0;
          cy= cy.value0;
          interval= interval.value0;
          svgObj.setAttribute("transform", "rotate("+value+", "+cx+", "+cy+")");
          return svgObj
        }
      }
    }
  }
}







