var GAME_OBJECT_LIST = []
var GAME_OBJECT_TAG_LIST = []
var CANVAS_WIDTH = 500;
var CANVAS_HEIGHT = 500;
var DRAW = undefined;
// tag=tag.value0;
exports.initGameBoard = function(gameBoard) {
  return function() {
  		gameBoard=gameBoard.value0
   		CANVAS_HEIGHT=parseInt(gameBoard.height)
  		CANVAS_WIDTH=parseInt(gameBoard.width)
	    
      if(DRAW)
	    	DRAW.clear();	
	  	DRAW=SVG(gameBoard.id).size(CANVAS_WIDTH, CANVAS_HEIGHT)
      
      GAME_OBJECT_TAG_LIST=[];
      addInTagCache("World")
      GAME_OBJECT_LIST = [];
      addInGameObjectCache("World",DRAW,"root")
  	}
}

exports["logAny"]  = function(a) {
  console.log(a);
}

exports.clearGameBoard = function() {
  	if(DRAW){
  		DRAW.clear()
    }
    GAME_OBJECT_TAG_LIST=[];
    GAME_OBJECT_LIST = [];  
    addInTagCache("World")
    addInGameObjectCache("World",DRAW,"root")
}

exports.getSvgNameCache = function() {
    return function() {
      return GAME_OBJECT_TAG_LIST;
    }
}

exports.addGameObject = function(parentNode) {
  return function(node) {
    return function() {
      parentNode=parentNode.value0
    	node=node.value0;
    	if(!isInTagCache(node.name) && DRAW){
         GAME_OBJECT_LIST.map(function(gameObject){
          if(gameObject.name === parentNode){
              var newGameObject = drawGameObject(gameObject.elem,node)
              addInTagCache(node.name);
              addInGameObjectCache(node.name,newGameObject,parentNode);
            }
          })
    	}
    }
  }
}

exports.modifyGameObject = function(name) {
  return function(propertyList) {
    return function() {
      name=name.value0;
      propertyList=propertyList.value0;
      var props = normalisePureProps(propertyList)
      GAME_OBJECT_LIST.map(function(gameObject){
        if(gameObject.name === name )
          gameObject.elem.attr(props);
      })
    }
  }
}

exports.getGameObjectProps = function(name) {
  return function() {
  	name=name.value0;
    console.error(name)
  	var object = findInGameObjectCache(name) 
		if(object)
      return deNormalisePureProps(object.props)
    else
      return []
  }
}

// fire a key up to toggle key state
exports.joyStickReleaseController = function(sub) {
  addEventListener("keydown", function(e) {
      sub({ keyCode: e.keyCode })
  })
}

exports.joyStickPressController = function(sub) {
  addEventListener("keyup", function(e) {
    sub({ keyCode: e.keyCode })
  })
}
// fire a key up to toggle key state
exports.keyController = function(sub) {
  var keyPressed = undefined;
  addEventListener("keydown", function(e) {
    keyPressed = e.keyCode
    sub({ keyCode: e.keyCode })
  })
  addEventListener("keyup", function(e) {
    keyPressed=undefined;
    if(keyPressed == e.keyCode)
      sub({ keyCode: e.keyCode })
  })
}


exports.removeGameObject = function(name) {
  return function() {
    name=name.value0;
    var newList = []
    var _gameObject = undefined ;
    GAME_OBJECT_LIST.map(function (gameObject) {
      if(gameObject.name!=name)
        newList.push(gameObject)
      else
        gameObject.elem.remove()
    })
    GAME_OBJECT_LIST=newList
  }
}

// { x, y , vx , vy } and Y axis is inversed
var collDet = function (obj,name,r1,r2) {
  if (  (  r1.x  <  r2.x + r2.w  )  &&  ( r1.x + r1.w  >  r2.x  )  && (  r1.y  <  r2.y + r2.h  )  && (  r1.y + r1.h  >  r2.y  )  )
      {   
          if( r1.vy != 0.0 ){
            if ( ( r1.y + r1.h + 2 ) > r2.y && obj.yP === "None")
                obj.yP  = name
            if ( ( r1.y + 2 ) > ( r2.y + r2.h ) && obj.yM === "None")
                obj.yM  = name
          }

          if(r1.vx != 0.0 ){
            if (  ( r1.x + r1.w + 2 ) > r2.x && obj.xP === "None")
                obj.xP  = name
            if (  ( r1.x + 2 ) > ( r2.x + r2.w ) && obj.xM === "None")
                obj.xM  = name
          }
      }
      return obj;
}



// { x, y , vx , vy }
exports.detectCollision = function(newObj) {
    return function (name) {
        newObj=newObj.value0
        name=name.value0
        var selectedObject = findInGameObjectCache(name) ;
        if(selectedObject){
          var selNode = selectedObject.elem.node
          var selProps = {
           x : newObj.x || parseInt(selNode.getAttribute('x')),
           y : newObj.y || parseInt(selNode.getAttribute('y')),
           h : parseInt(selNode.getAttribute('height')),
           w : parseInt(selNode.getAttribute('width')),
           vx : newObj.vx || 0.0 ,
           vy : newObj.vy || 0.0
          }  

          var collision =  { 
            xP : "None",
            xM : "None",
            yP : "None",
            yM : "None"
          }
          GAME_OBJECT_LIST.map(function (gameObject) {
            if(gameObject.name!=name && gameObject.parent == "Obstacles" ){
                var objProps = {
                  x :     parseInt(gameObject.elem.node.getAttribute('x')),
                  y :     parseInt(gameObject.elem.node.getAttribute('y')),
                  h :     parseInt(gameObject.elem.node.getAttribute('height')),
                  w :     parseInt(gameObject.elem.node.getAttribute('width'))
                }
                collision = collDet(collision,gameObject.name,selProps,objProps) 
            }
          })

          // COLLIDABLE_PRP
        }
        // console.log(collision)
        return collision;
    }
}


//HELPER FUNCTIONS
var normalisePureProps = function mapToSvg(pureProps) {
    var props= {}
    pureProps.map(function mapToSvg(param) {
      param=param.value0;
      props[param.key]=param.value
    });
    return props;
}

var deNormalisePureProps = function mapFromSvg(svgProps) {
  	var props= []
  	pureProps.map(function mapToSvg(param) {
      console.error(param)
      props.push({
        key : param,
        value : param
      })
  		props[param.key]=param.value
  	});
  	return props;
}

var drawGameObject = function (svg,node) {
  var type = node.nodeType;
  var props = normalisePureProps(node.props)
  var elem = null;
  if(type == "Rectangle") {
    elem = svg.rect().attr(props);
  } else if(type == "Circle") {
    elem = svg.circle(props.radius);
  } else if(type == "TextArea") {
    elem = svg.text(props.text).attr(props).font(props);
  } else if(type == "Path") {
    // TODO : FIX ME
  } else if(type == "Oval") {
    elem = svg.ellipse().attr(props)
  } else if(type == "Image") {
    elem = svg.image(props.path).loaded(function(loader) {
            var newProp = {}
            var sX = props.width / loader.width
            var sY = props.height / loader.height
            newProp.x = ( elem.attr('x') ||  props.x )/ sX
            newProp.y = ( elem.attr('y') || props.y ) / sY
            newProp.width= loader.width
            newProp.height= loader.height
            newProp.transform ="scale("+sX+","+sY+")" 
            elem.attr(newProp);
        })
    elem.attr(props);      
  } else if(type == "Group") {
    elem = svg.group().attr(props);
  } else {
    throw new Error("Unsupported type");
  }
  return elem;
};

var drawGroup = function (parentGroup,tree) {
  var svgElem = drawNode(parentGroup,tree[0]);
}

var isInTagCache = function (tag) {
	var isPresent =false;
	if(!GAME_OBJECT_TAG_LIST)
		GAME_OBJECT_TAG_LIST=[];
	GAME_OBJECT_TAG_LIST.map(function (cacheTag) {
		if(cacheTag==tag)
			isPresent=true

	})
	return isPresent;
}

var addInTagCache = function (tag) {
	if(!isInTagCache(tag))
		GAME_OBJECT_TAG_LIST.push(tag)
}

var addInGameObjectCache = function (_tag,gameObject,parentName) {
	if(!GAME_OBJECT_LIST)
		GAME_OBJECT_LIST=[]
	GAME_OBJECT_LIST.push({
		name : _tag,
		elem : gameObject,
    parent : parentName
	})
}

var findInGameObjectCache = function (name) {
  var _gameObject = undefined ;
  GAME_OBJECT_LIST.map(function (gameObject) {
    if(gameObject.name==name)
      _gameObject=gameObject

  })
  return _gameObject;
}
