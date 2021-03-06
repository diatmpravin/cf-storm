require_relative '../helper'

scope do

  test 'should format a number to percentage for cpu usage when is extremely small' do
    assert req.cpu_usage(2.322687459237046e-05) == '0.00%'
  end

  test 'should format a number to percentage for cpu usage when is high' do
    assert req.cpu_usage(0.24566817) == '24.57%'
  end

  test 'should humanize memory amount' do
    assert req.to_megabytes(19628032) == '18.72 MB'
  end

  test 'should convert seconds in days hours:mins:secs' do
    assert req.human_time(17288000) == '200 days 02:13:20'
  end

  test 'should return app path' do
    @space = FakeClient.new.spaces.first
    @app = @space.apps.first
    assert req.app_path(@space, @app) == URI.encode("/spaces/#{@space.name}/apps/#{@app.name}")
  end

  test 'should return 100 health percentage of app' do
    @app.health_with(2, 0)
    assert req.app_health(@app, @app.stats) == '100'
  end

  test 'should return 50 health percentage of app when half of its instances are running' do
    @app.health_with(1, 1)
    assert req.app_health(@app, @app.stats) == '50'

    @app.health_with(2, 2)
    assert req.app_health(@app, @app.stats)
  end

  test 'should return 25 health percentage of app when one out of four instances is running' do
    @app.health_with(1, 3)
    assert req.app_health(@app, @app.stats) == '25'
  end

  test 'should return 0 health when no instances are running' do
    @app.health_with(0, 1)
    assert req.app_health(@app, @app.stats) == '0'
  end

  test 'should return integer number of health' do
    @app.health_with(1, 2)
    assert req.app_health(@app, @app.stats) == '33'
  end

end
