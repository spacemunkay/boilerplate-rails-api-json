module Api::V1
  class ExampleController < VersionController
    def example
      render :json => { :message => 'Well done!' }
    end
  end
end
