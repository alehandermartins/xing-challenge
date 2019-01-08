module Api
  class PlayListsController < ApiController
    before_action :authenticate_user!
    before_action :set_play_list, except: [:index, :create]
    before_action :set_mp3, only: [:add_mp3, :remove_mp3]

    def index
      @play_lists = current_user.play_lists

      render json: @play_lists
    end

    def create
      @play_list = PlayList.new(play_list_params)

      if @play_list.save
        render json: @play_list, status: :created
      else
        render json: @play_list.errors, status: :unprocessable_entity
      end
    end

    def update
      if @play_list.update(play_list_params)
        render json: @play_list
      else
        render json: @play_list.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: @play_list
    end

    def destroy
      @play_list.destroy
    end

    def add_mp3
      if @play_list && @mp3
        @play_list.mp3s << @mp3
        render status: 200
      else
        render status: 404
      end
    end

    def remove_mp3
      if @play_list && @mp3
        @play_list.mp3s.delete(@mp3)
        render status: 200
      else
        render status: 404
      end
    end

    private

      def set_play_list
        @play_list = current_user.play_lists.find_by_id(params[:id])
      end

      def play_list_params
        params.require(:play_list).permit(:name).merge(user: current_user)
      end

      def set_mp3
        @mp3 = Mp3.find_by_id(mp3_params[:mp3_id])
      end

      def mp3_params
        params.require(:mp3).permit(:mp3_id)
      end
  end
end
