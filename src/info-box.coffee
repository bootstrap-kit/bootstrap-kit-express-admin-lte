module.exports = (bootstrapKit) ->
  {WebComponent, addViewProvider, makeElement} = bootstrapKit

  # Public: InfoBox
  #
  # Create an InfoBox.
  #
  # Here you find examples how to create the infoboxes on
  # https://almsaeedstudio.com/AdminLTE
  #
  # Example:
  # ```coffee
  # infobox = new InfoBox {
  #   icon: 'ion-ios-gear-outline'
  #   title: 'CPU TRAFFIC'
  #   name: 'cpuTraffic'
  #   value: '90%'
  # }
  # # later you can update data
  # infoBox.updateData cpuTraffic: '80%'
  # ```
  #
  # You can also add multiple values:
  # ```coffee
  # infobox = new InfoBox {
  #   icon: 'ion-ios-gear-outline'
  #   infos: [
  #     { title: 'CPU TRAFFIC',     name: 'cpuTraffic' }
  #     { title: 'NETWORK TRAFFIC', name: 'networkTraffic' }
  #   ]
  # }
  # infoBox.updateData cpuTraffic: '80%', networkTraffic: '12Mb/s'
  # ```
  #
  class InfoBox extends WebComponent
  bootstrapKit.InfoBox = InfoBox

  class InfoBoxElement extends HTMLDivElement
    setModel: (@model) ->
      @classList.add 'col-md-3', 'col-sm-6', 'col-xs-12'

      iconCode = ''
      if @model.options?.icon?.match /^https?:\/\//
        iconCode = """<img src="#{@model.options.icon}">"""
      else if m = @model.options?.icon?.match /^(\w+)\-/
        iconCode = """<i class="#{m[1]} #{@model.options.icon}"></i>"""

      statusClass = @model.options?.statusClass or 'bg-aqua'

      @innerHTML =  """
        <div class="info-box">
          <span class="info-box-icon #{statusClass}">#{iconCode}</span>
          <div class="info-box-content">
          </div>
          <!-- /.info-box-content -->
        </div>
        <!-- /.info-box -->
        """

      infoBoxContent = @querySelector('.info-box-content')
      infoBoxStatus  = @querySelector('.info-box-icon')

      console.log "hello world"

      @statusClass = 'bg-green'

      infos = @model.options.infos

      if infos
        # if multiple infos given prepare element to contain multiple ones
        infoBoxContent.classList.add 'row'

        #row" style="padding-left: 0;padding-right: 5px">

        for info in infos
          value = info.value or ''
          name = info.name or ''
          infoBoxContent.appendChild makeElement """
            <div class="col-md-6 col-sm-6 col-xs-12">
              <span class="info-box-text">#{info.title}</span>
              <span class="info-box-number #{name}">#{value}</span>
            </div>
          """

      else if @model.options.title
        info = @model.options
        value = info.value or ''
        name = info.name or ''
        infoBoxContent.innerHTML = """
          <span class="info-box-text">#{info.title}</span>
          <span class="info-box-number #{name}">#{value}</span>
        """

      @model.onDidUpdateData ({changes,data}) =>
        console.log "did update data"
        for k,{newValue} of changes
          if e = @querySelector(".#{k}")
            e.textContent = newValue

        if @model.options?.getStatusClass
          infoBoxStatus.classList.remove(@statusClass)
          @statusClass = @model.options.getStatusClass(data)
          infoBoxStatus.classList.add(@statusClass)

      this

  InfoBoxElement = document.registerElement 'info-box', extends: 'div', prototype: InfoBoxElement::

  addViewProvider InfoBox, InfoBoxElement

  InfoBox
