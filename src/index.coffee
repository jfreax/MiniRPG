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

    percentage = @heightOfField * 0.8
    propotationFactor = 2.5
    distance = {x: WIDTH / (propotationFactor*@heightOfField - 1 + percentage), y:  HEIGHT / @heightOfField}

    for i in [0..@heightOfField-1]
      heightChance = Math.abs((@heightOfField/2-i) / @heightOfField/2) * 2.5
      heightChance = heightChance*heightChance * 2

      oldNode = undefined
      for j in [2..propotationFactor*@heightOfField - 1 + randomIntFromInterval(-percentage, percentage)]
        widthChance = Math.abs(((propotationFactor/2) * @heightOfField)-j) / ((propotationFactor/2) * @heightOfField) * 0.8

        if Math.random() - heightChance > widthChance
          # add a new node
          newNode = new Node(
            Math.round(distance.x * (j-0.5) + randomIntFromInterval(0, distance.x/3)),
            Math.round(distance.y * (i+0.5)),
            i, j)
          @addNode(newNode, i, j)

          # connect with other nodes
          if oldNode != undefined
            # with direct right neighbour
            @connectNode(oldNode, newNode)

          # and maybe, add some diagonal connections
          if @nodes[i-1] != undefined
            chanceFactor = 1
            nodesToConnect = []
            for x in [-4..4]
              nodesToConnect.push(@nodes[i-1][j+x])

            for nodeToConnect in nodesToConnect
              if nodeToConnect != undefined and nodeToConnect.connection.length < 2 and Math.random() * chanceFactor > 0.0
                console.log("Connect!")
                @connectNode(newNode, nodeToConnect)
                chanceFactor = 0.8

          # test if all levels are connected
          #connected = []
          #for a in [0..@heightOfField-1]
          #  if @nodes[a] != undefined
          #    for start in @nodes[a]
          #      if start != undefined
          #        for end in start.connection
          #          if start.i == end.i + 1
          #            connected[start.i] = true
          #            break;

          #for a in [1..@heightOfField-1]
          #  if connected[a] == undefined || connected[a] == false
          #    startNode = undefined
          #    endNode = undefined
          #    for start in @nodes[a]
          #      if start != undefined
          #        startNode = start
          #        break;
          #    @connectNode(newNode, nodeToConnect)

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
    for a in [0..@heightOfField-1]
      if @nodes[a] != undefined
        for start in @nodes[a]
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

