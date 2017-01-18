class RoomsController < ApplicationController
  protect_from_forgery :only => ["create"]
  def join
    @room = Room.find(params[:room_id])
    @user = User.find(params[:users_id])
    makeshadow(@room, @user)
    redirect_to "/rooms/home/#{@room.id}/#{@user.id}"
  end

  def delete
    @room = Room.find(params[:room_id])
    @user = User.find(params[:user_id])
    @room.users.delete(@user)
    redirect_to "/users/show/#{@user.id}"
  end

  def create
    @user = User.find(params[:users_id])
    @user_id = @user.id
    @room = Room.new(name: params[:roomname])
    @room.users << User.find(@user_id)
    @room.save
    seed(@room)
    redirect_to "/users/show/#{@user_id}"
  end

  def home
    @room = Room.find(params[:room_id])
    @user = User.find(params[:user_id])
  end

  def post
    @room = Room.find(params[:room_id])
    @user = User.find(params[:user_id])
    edit = JSON.parse(params[:edit])
    patch(edit,0)
    patch(edit,@user.id)
    data = diff(@room,@user)
    unless data == []
      shadow(@room, @user)
    end
    render json: data
  end

  private

    def grant(user,type)
      last = SecureRandom.uuid
      if type == 0
        if Vertex.last
          last = Vertex.last.id
        else
          last = 0
        end
      elsif type == 1
        if Face.last
          last = Face.last.id
        else
          last = 0
        end

      elsif type == 2
        if Mesh.last
          last = Mesh.last.id
        else
          last = 0
        end
      end
      num = [user,type,last,SecureRandom.base64(2)].join('')
    end

    def seed(room)
      @scene = room.scenes.create(
        :aff => 0
      )
      @scene.save

      @mesh = @scene.meshes.create(
        :uuid => grant(0,2),
      )
      @mesh.save

      # @face = @scene.faces.create(
      #   :uuid => grant(0,1),
      # )
      # @face.save

      vertex_uuid = grant(0,0)
      @vertex1 = @scene.vertices.create(
        :uuid => vertex_uuid,
        :axis => "x",
        :data => 10,
      )
      @vertex2 = @scene.vertices.create(
        :uuid => vertex_uuid,
        :axis => "y",
        :data => 10,
      )
      @vertex3 = @scene.vertices.create(
        :uuid => vertex_uuid,
        :axis => "z",
        :data => 10,
      )

      @vertex1.save
      @vertex2.save
      @vertex3.save
    end

    def diff(room,user)
      # serverTextとserverShadowのデータの差分
      edit = []
      @servertext_array = {
        :meshes_id => [],
        :faces_id => [],
        :vertices_id => []
      }

      @servershadow_array = {
        :meshes_id => [],
        :faces_id => [],
        :vertices_id => []
      }

      servertext = room.scenes.find_by(:aff => 0)
      servershadow = room.scenes.find_by(:aff => user.id)


      servertext.meshes.each do |mesh|
        @servertext_array[:meshes_id].push(mesh.uuid)
      end
      servertext.faces.each do |face|
        @servertext_array[:faces_id].push(face.uuid)
      end
      servertext.vertices.each do |vertex|
        @servertext_array[:vertices_id].push(vertex.uuid)
      end

      servershadow.meshes.each do |mesh|
        @servershadow_array[:meshes_id].push(mesh.uuid)
      end
      servershadow.faces.each do |face|
        @servershadow_array[:faces_id].push(face.uuid)
      end
      servershadow.vertices.each do |vertex|
        @servershadow_array[:vertices_id].push(vertex.uuid)
      end

      len_t = @servertext_array[:meshes_id].length
      len_s = @servershadow_array[:meshes_id].length
      for i in 0...len_t do
        pre = @servershadow_array[:meshes_id].index(@servertext_array[:meshes_id][i])
        unless pre
          ope = [  "mesh",
                   @servertext_array[:meshes_id][i],
                   0
          ]
          edit.push(ope)
        end
      end

      for i in 0...len_s do
        pre = @servertext_array[:meshes_id].index(@servershadow_array[:meshes_id][i])
        unless pre
          ope = [  "demesh",
                   @servershadow_array[:meshes_id][i],
                   0
          ]
          edit.push(ope)
        end
      end

      len_t = @servertext_array[:faces_id].length
      len_s = @servershadow_array[:faces_id].length
      for i in 0...len_t do
        pre = @servershadow_array[:faces_id].index(@servertext_array[:faces_id][i])
        unless pre
          face_array = []
          vertices = servertext.vertices.where(:face_id => @servertext_array[:faces_id][i])
          vertices.each do | vertex |
            if vertex.axis == "x"
              face_array.push(vertex.uuid)
            end
          end
          ope = [  "face",
                   @servertext_array[:faces_id][i],
                   face_array
          ]
          edit.push(ope)
        end
      end

      for i in 0...len_s do
        pre = @servertext_array[:faces_id].index(@servershadow_array[:faces_id][i])
        unless pre
          ope = [  "deface",
                   @servershadow_array[:faces_id][i],
                   0
          ]
          edit.push(ope)
        end
      end

      text = {
        :x => 0,
        :y => 0,
        :z => 0
      }
      shado = {
        :x => 0,
        :y => 0,
        :z => 0
      }

      len_t = @servertext_array[:vertices_id].length
      len_s = @servershadow_array[:vertices_id].length
      for i in 0...len_t do
        pre = @servershadow_array[:vertices_id].index(@servertext_array[:vertices_id][i])
        servertext.vertices.each do |vertex|
          if vertex.uuid == @servertext_array[:vertices_id][i]
            if vertex.axis == "x"
              text[:x] = vertex.data
            elsif vertex.axis == "y"
              text[:y] = vertex.data
            elsif vertex.axis == "z"
              text[:z] = vertex.data
            end
          end
        end

        servershadow.vertices.each do |vertex|
          if vertex.uuid == @servershadow_array[:vertices_id][i]
            if vertex.axis == "x"
              shado[:x] = vertex.data
            elsif vertex.axis == "y"
              shado[:y] = vertex.data
            elsif vertex.axis == "z"
              shado[:z] = vertex.data
            end
          end
        end

        if pre
          if text[:x] != shado[:x] || text[:y] != shado[:y] || text[:z] != shado[:z]
            ope = [  "move",
                     @servertext_array[:vertices_id][i],
                     [
                         text[:x],
                         text[:y],
                         text[:z]
                     ]
            ]
            edit.push(ope)
          end
        else
          ope = [  "add",
                   @servertext_array[:vertices_id][i],
                   [
                     text[:x],
                     text[:y],
                     text[:z]
                   ]
          ]
          edit.push(ope)
        end
      end

      for i in 0...len_s do

        servertext.vertices.each do |vertex|
          if vertex.uuid == @servertext_array[:vertices_id][i]
            if vertex.axis == "x"
              text[:x] = vertex.data
            elsif vertex.axis == "y"
              text[:y] = vertex.data
            elsif vertex.axis == "z"
              text[:z] = vertex.data
            end
          end
        end

        servershadow.vertices.each do |vertex|
          if vertex.uuid == @servershadow_array[:vertices_id][i]
            if vertex.axis == "x"
              shado[:x] = vertex.data
            elsif vertex.axis == "y"
              shado[:y] = vertex.data
            elsif vertex.axis == "z"
              shado[:z] = vertex.data
            end
          end
        end

        pre = @servertext_array[:vertices_id].index(@servershadow_array[:vertices_id][i])
        unless pre
          ope = [  "remove",
                   @servershadow_array[:vertices_id][i],
                   [
                     shado[:x],
                     shado[:y],
                     shado[:z]
                   ]
          ]
          edit.push(ope)
        end
      end
      edit
    end

    def patch(edit,aff)
      # serverTextとserverShadowの値の書き換え
      scene = Scene.find_by(:aff => aff)
      for i in 0...edit.length
        ope = edit[i][0]
        id = edit[i][1]
        data = edit[i][2]
        if ope == 'add'
          vertex_uuid = id
          @vertex1 = scene.vertices.create(
            :uuid => vertex_uuid,
            :axis => "x",
            :data => data[0]
          )
          @vertex2 = scene.vertices.create(
            :uuid => vertex_uuid,
            :axis => "y",
            :data => data[1]
          )
          @vertex3 = scene.vertices.create(
            :uuid => vertex_uuid,
            :axis => "z",
            :data => data[2]
          )
          @vertex1.save
          @vertex2.save
          @vertex3.save
        elsif ope == 'remove'
          scene.vertices.each do |vertex|
            if vertex.uuid == id
              vertex.destroy
            end
          end
        elsif ope == 'face'
          @face = scene.faces.create(
            :uuid => id
          )
          @face.save
          face = scene.faces.find_by(:uuid => id)
          data.each do |uuid|
            @vertex_x = Vertex.find_by(:uuid => uuid,:axis => "x").data
            @vertex_y = Vertex.find_by(:uuid => uuid,:axis => "y").data
            @vertex_z = Vertex.find_by(:uuid => uuid,:axis => "z").data
            @vertex1 = scene.vertices.create(
              :uuid => uuid,
              :axis => "x",
              :data => @vertex_x,
              :face_id => face.id
            )
            @vertex2 = scene.vertices.create(
              :uuid => uuid,
              :axis => "y",
              :data => @vertex_y,
              :face_id => face.id

            )
            @vertex3 = scene.vertices.create(
              :uuid => uuid,
              :axis => "z",
              :data => @vertex_z,
              :face_id => face.id

            )
            @vertex1.save
            @vertex2.save
            @vertex3.save
          end

        elsif ope == 'mesh'
          @mesh = scene.meshes.create(
            :uuid => id
          )
          @mesh.save
        elsif ope == 'demesh'
          mesh = scene.meshes.find_by(:uuid => id)
          mesh.destroy
        elsif ope == 'deface'
          face = scene.faces.find_by(:uuid => id)
          face.destroy
        elsif ope == 'move'
          scene.vertices.each do |vertex|
            if vertex.uuid == id
              if vertex.axis == "x"
                vertex.data = data[0]
              elsif vertex.axis == "y"
                vertex.data = data[1]
              elsif vertex.axis == "z"
                vertex.data = data[2]
              end
              vertex.save
            end
          end
        end
      end
    end

    def makeshadow(room,user)
      @scene = room.scenes.find_by(:aff => user.id)
      if @scene
        @scene.destroy
      end
      @scene = room.scenes.create(
        :aff => user.id
      )
      @scene.save
    end

    def shadow(room, user)
      # すでにあるserverShadowを削除
      # roomのaffがuser.idのsceneに紐づいているやつ全部とscene自体を削除
      servershadow = room.scenes.find_by(:aff => user.id)
      if servershadow
        servershadow.meshes.each do |mesh|
          if mesh
            mesh.destroy
          end
        end
        servershadow.faces.each do |face|
          if face
            face.destroy
          end
        end
        servershadow.vertices.each do |vertex|
          if vertex
            vertex.destroy
          end
        end
        servershadow.destroy
      end
      # 今このroomにあるmeshをaffを書き換えて再保存 :aff => user.name
      servertext = room.scenes.find_by(:aff => 0)
      @scene = room.scenes.create(
        :aff => user.id
      )
      @scene.save

      servertext.meshes.each do |mesh|
        @mesh = @scene.meshes.create(
          :uuid => mesh.uuid
        )
        @mesh.save
      end
      servertext.faces.each do |face|
        @face = @scene.faces.create(
          :uuid => face.uuid
        )
        @face.save
      end
      servertext.vertices.each do |vertex|
        @vertex = @scene.vertices.create(
          :uuid => vertex.uuid,
          :axis => vertex.axis,
          :data => vertex.data
        )
        @vertex.save
      end
    end
end
