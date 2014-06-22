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
  connectedNodes: []

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

    percentage = @heightOfField * 0.8
    propotationFactor = 2.5
    distance = {x: WIDTH / (propotationFactor*@heightOfField - 1 + percentage), y:  HEIGHT / @heightOfField}

    for i in [0..@heightOfField-1]
      heightChance = Math.abs((@heightOfField/2-i) / @heightOfField/2) * 2.5

      oldNode = undefined
      for j in [2..propotationFactor*@heightOfField - 1 + randomIntFromInterval(-percentage, percentage)]
        widthChance = Math.abs(((propotationFactor/2) * @heightOfField)-j) / ((propotationFactor/2) * @heightOfField)

        if Math.random() - heightChance > widthChance
          newNode = new Node(distance.x * (j-0.5) + randomIntFromInterval(0, distance.x/3), distance.y * (i+0.5))
          @addNode(newNode)

          if oldNode != undefined
            @connectNode(oldNode, newNode)
          oldNode = newNode

  run: () =>
      requestAnimFrame(@run)
      @renderer.render(@stage)

  addNode: (node) =>
    @stage.addChild(node)

  connectNode: (start, end, addToList = true) =>
    if addToList
      @connectedNodes.push({start: start, end: end})

    @graphics.beginFill(0x0);
    @graphics.lineStyle(10, 0xFFFFFF, 1);
    @graphics.moveTo(start.position.x, start.position.y);
    @graphics.lineTo(end.position.x, end.position.y);
    @graphics.endFill();

  onresize: () =>
    @renderer.resize(window.innerWidth, window.innerHeight)
    for child in @stage.children
      if child instanceof Node
        child.init()

    @graphics.clear()
    for connections in @connectedNodes
      @connectNode(connections.start, connections.end, false)

##
#
##
class Node extends PIXI.Sprite
  SIZE: 10

  backgroundColor = 0x85b9bb
  borderColor = 0x476263

  constructor: (x, y) ->
    graphics = new PIXI.Graphics()
    graphics.beginFill(backgroundColor)
    graphics.lineStyle(1, borderColor, 1)
    graphics.drawCircle(0, 0, @SIZE)
    graphics.endFill()

    texture = graphics.generateTexture()
    super texture

    @originalPosition = {x: x, y: y }
    @init()

  init: () =>
    scale = {x: window.innerWidth / WIDTH, y: window.innerHeight / HEIGHT }

    @interactive = true
    @position.x = @originalPosition.x * scale.x
    @position.y = @originalPosition.y * scale.y
    @anchor.x = 0.5
    @anchor.y = 0.5

  mousedown: (touchData) ->
    console.log("DOWN!")

# $ ->
game = new Game(2, 5)
requestAnimFrame(game.run)

