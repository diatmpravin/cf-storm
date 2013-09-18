module AppsHelper
  def app_state_icon_class app
    app.started? ? 'label label-success icon-ok app-state-started' :
                   'label label-inportant icon-remove app-state-stopped'
  end

  def app_state_icon app
    if app.started?
      '<span class="badge badge-success app-state-started"><i class="icon-ok"></i></span>'
    else
      '<span class="badge badge-important app-state-stopped"><i class="icon-remove"></i></span>'
    end
  end

  def app_label_state_class app
    app.started? ? 'label label-success' : 'label label-important'
  end

  def app_state_class app
    app.started? ? "stop-#{app.name}" : "start-#{app.name}"
  end

  def cpu_usage number
    "%.2f%" % number
  end

  def to_megabytes bytes
    mega_bytes = (bytes / 1024.0) / 1024.0
    "%.2f MB" % mega_bytes
  end

  def human_time seconds
    days       = seconds / 86400
    remaining  = seconds % 86400
    "#{days} days #{Time.at(remaining).gmtime.strftime('%R:%S')}"
  end

  def app_path space, app
    "/spaces/#{space.name}/apps/#{app.name}"
  end

  def instance_status_class instance
    return 'label label-success' if instance[:state] == 'STARTED'
    return 'label label-success' if  instance[:state] == 'RUNNING'
    return 'label label.important' if instance[:state] == 'STOPPED'
    return 'label'
  end

  def app_map_url_path space, app
    app_path(space, app) + '/map_url'
  end

end
