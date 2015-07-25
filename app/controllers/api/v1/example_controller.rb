module Api::V1
  class ExampleController < VersionController

    MESSAGE = 'Well done!'

    def example
      render :json => { :message => MESSAGE }
    end
  end
end
