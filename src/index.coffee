WIDTH = 800
HEIGHT = 400

##
#
##
randomIntFromInterval = (min,max) ->
  return Math.floor(Math.random()*(max-min+1)+min)


##
#
##
class Game
  graphics: new PIXI.Graphics();
  nodes: []

  constructor: (@numberOfPlayer, @heightOfField) ->
    # create an new instance of a pixi stage
    @stage = new PIXI.Stage(0xEEEEEE)
    @renderer = PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight)
    document.body.appendChild(@renderer.view)

    @initEvents()
    @init()

  initEvents: () =>
    # Global events
    window.onresize = () =>
      @onresize()

  init: () =>
    @stage.addChild(@graphics);
    @maxWidth = 3.5 * @heightOfField

    # init 2d node array
    for i in [0..@maxWidth]
      @nodes[i] = []

    half = @heightOfField / 2
    distance = {x: WIDTH / @maxWidth, y:  HEIGHT / @heightOfField}

    # for each level
    for lvl in [0..@heightOfField-1]
      widthOnThisLevel = @maxWidth - @maxWidth * Math.abs((half - lvl) / @heightOfField)
      widthOnThisLevel = widthOnThisLevel*widthOnThisLevel / 20
      console.log(widthOnThisLevel)
      widthOnThisLevel -= randomIntFromInterval(0, @maxWidth*0.3)

      # add nodes
      toCenter = (@maxWidth - widthOnThisLevel) / 2
      oldNode = undefined
      for w in [toCenter..widthOnThisLevel+toCenter]
        newNode = new Node(
          Math.round(distance.x * (w-0.5) + randomIntFromInterval(0, distance.x/3)),
          Math.round(distance.y * (lvl+0.5)), lvl, w)
        @addNode(newNode, Math.round(lvl), Math.round(w))

        # connect with other nodes
        if oldNode != undefined
          # with direct right neighbour
          @connectNode(oldNode, newNode)

        # and maybe, add some diagonal connections
        if @nodes[lvl-1] != undefined
          chanceFactor = 1
          nodesToConnect = []
          for x in [-2..2]
            nodesToConnect.push(@nodes[Math.round(lvl)-1][Math.round(w)+x])

          for nodeToConnect in nodesToConnect
            console.log(nodeToConnect)
            if nodeToConnect != undefined and nodeToConnect.connection.length < 3 and Math.random() > 0.4
              console.log("Connect!")
              @connectNode(newNode, nodeToConnect)
              chanceFactor = 0.8


        # remember old node
        oldNode = newNode

  run: () =>
      requestAnimFrame(@run)
      @renderer.render(@stage)

  addNode: (node, i, j) =>
    if @nodes[i] == undefined
      @nodes[i] = []
    @nodes[i][j] = node
    @stage.addChild(node)

  connectNode: (start, end, addToList = true) =>
    if addToList
      start.addConnection(end)
      end.addConnection(start)

    @graphics.beginFill(0x0);
    @graphics.lineStyle(10, 0xCDCDCD, 1);
    @graphics.moveTo(start.position.x, start.position.y);
    @graphics.lineTo(end.position.x, end.position.y);
    @graphics.endFill();

    @graphics.beginFill(0x0);
    @graphics.lineStyle(8, 0xFFFFFF, 1);
    @graphics.moveTo(start.position.x, start.position.y);
    @graphics.lineTo(end.position.x, end.position.y);
    @graphics.endFill();

  onresize: () =>
    @renderer.resize(window.innerWidth, window.innerHeight)
    for child in @stage.children
      if child instanceof Node
        child.init()

    @graphics.clear()
    for lvl in [0..@heightOfField-1]
      if @nodes[lvl] != undefined
        for start in @nodes[lvl]
          if start != undefined
            for end in start.connection
              @connectNode(start, end, false)

##
#
##
class Node extends PIXI.Sprite
  SIZE: 10

  backgroundColor = 0x85b9bb
  borderColor = 0x476263

  constructor: (x, y, @i, @j) ->
    graphics = new PIXI.Graphics()
    graphics.beginFill(backgroundColor)
    graphics.lineStyle(1, borderColor, 1)
    graphics.drawCircle(0, 0, @SIZE)
    graphics.endFill()

    texture = graphics.generateTexture()
    super texture

    @connection = []
    @originalPosition = {x: x, y: y }
    @init()

  init: () =>
    scale = {x: Math.max(window.innerWidth / WIDTH, 1), y: Math.max(window.innerHeight / HEIGHT, 1)}

    @interactive = true
    @position.x = @originalPosition.x * scale.x
    @position.y = @originalPosition.y * scale.y
    @anchor.x = 0.5
    @anchor.y = 0.5

  addConnection: (endNode) =>
    @connection.push(endNode)

  mousedown: (touchData) ->
    console.log("DOWN!")

# $ ->
game = new Game(2, 5)
requestAnimFrame(game.run)

