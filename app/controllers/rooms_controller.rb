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

      @face = @scene.faces.create(
        :uuid => grant(0,1),
      )
      @face.save

      vertex_uuid = grant(0,0)
      @vertex1 = @scene.vertices.create(
        :uuid => vertex_uuid,
        :component => "x",
        :data => 10,
      )
      @vertex2 = @scene.vertices.create(
        :uuid => vertex_uuid,
        :component => "y",
        :data => 10,
      )
      @vertex3 = @scene.vertices.create(
        :uuid => vertex_uuid,
        :component => "z",
        :data => 10,
      )

      @vertex1.save
      @vertex2.save
      @vertex3.save

      vertex_uuid = grant(0,0)
      @vertex1 = @scene.vertices.create(
        :uuid => vertex_uuid,
        :component => "x",
        :data => 20,
      )
      @vertex2 = @scene.vertices.create(
        :uuid => vertex_uuid,
        :component => "y",
        :data => 20,
      )
      @vertex3 = @scene.vertices.create(
        :uuid => vertex_uuid,
        :component => "z",
        :data => 20,
      )

      @vertex1.save
      @vertex2.save
      @vertex3.save
    end

    def diff(room,user)
    edit = []
    servertext = room.scenes.find_by(:aff => 0)
    servershadow = room.scenes.find_by(:aff => user.id)

    @servertext_array = {
      :mesh => [],
      :meshes_id => [],
      :faces => [],
      :faces_id => [],
      :vertices => [],
      :vertices_id => []
    }

    @servershadow_array = {
      :mesh => [],
      :meshes_id => [],
      :faces => [],
      :faces_id => [],
      :vertices => [],
      :vertices_id => []
    }

    servertext.meshes.each do |mesh|
      @servertext_array[:meshes_id].push(mesh.uuid)
      array = []
      mesh.faces.each do |face|
        unless array.index(face.uuid)
          array.push(face.uuid)
        end
      end
      @servertext_array[:mesh].push(array)
    end
    servertext.faces.each do |face|
      @servertext_array[:faces_id].push(face.uuid)
      array = []
      face.vertices.each do |vertex|
        unless array.index(vertex.uuid)
          array.push(vertex.uuid)
        end
      end
      @servertext_array[:faces].push(array)
    end
    servertext.vertices.each do |vertex|
      unless @servertext_array[:vertices_id].index(vertex.uuid)
        @servertext_array[:vertices_id].push(vertex.uuid)
        vertex_x = servertext.vertices.find_by(:uuid => vertex.uuid, :component => "x")
        vertex_y = servertext.vertices.find_by(:uuid => vertex.uuid, :component => "y")
        vertex_z = servertext.vertices.find_by(:uuid => vertex.uuid, :component => "z")
        @servertext_array[:vertices].push(vertex_x.data,vertex_y.data,vertex_z.data)
      end
    end


    servershadow.meshes.each do |mesh|
      @servershadow_array[:meshes_id].push(mesh.uuid)
      array = []
      mesh.faces.each do |face|
        unless array.index(face.uuid)
          array.push(face.uuid)
        end
      end
      @servershadow_array[:mesh].push(array)
    end
    servershadow.faces.each do |face|
      @servershadow_array[:faces_id].push(face.uuid)
      array = []
      face.vertices.each do |vertex|
        unless array.index(vertex.uuid)
          array.push(vertex.uuid)
        end
      end
      @servershadow_array[:faces].push(array)
    end
    servershadow.vertices.each do |vertex|
      unless @servershadow_array[:vertices_id].index(vertex.uuid)
        @servershadow_array[:vertices_id].push(vertex.uuid)
        vertex_x = servershadow.vertices.find_by(:uuid => vertex.uuid, :component => "x")
        vertex_y = servershadow.vertices.find_by(:uuid => vertex.uuid, :component => "y")
        vertex_z = servershadow.vertices.find_by(:uuid => vertex.uuid, :component => "z")
        @servershadow_array[:vertices].push(vertex_x.data,vertex_y.data,vertex_z.data)
      end
    end

      p @servertext_array
      p @servershadow_array

      len_t = @servertext_array[:meshes_id].length
      len_s = @servershadow_array[:meshes_id].length
      for i in 0...len_t do
        pre = @servershadow_array[:meshes_id].index(@servertext_array[:meshes_id][i])
        if pre
          if @servershadow_array[:mesh][pre] != @servertext_array[:mesh][i]
            ope = [  "mesh_update",
                     @servertext_array[:meshes_id][i],
                     [
                       @servertext_array[:mesh][i][@servertext_array[:mesh].length - 1]
                     ]
            ]
            edit.push(ope)
          end
        else
          ope = [  "mesh_add",
                   @servertext_array[:meshes_id][i],
                   0
          ]
          edit.push(ope)
        end
      end
      for i in 0...len_s do
        pre = @servertext_array[:meshes_id].index(@servershadow_array[:meshes_id][i])
        unless pre
          ope = [  "mesh_remove",
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
        if pre
          if @servershadow_array[:faces][pre] != @servertext_array[:faces][i]
            ope = [  "face_update",
                     @servertext_array[:faces_id][i],
                     [
                      @servertext_array[:faces][i][@servertext_array[:faces][i].length - 1]
                     ]
            ]
            edit.push(ope)
          end
        else
          ope = [  "face_add",
                   @servertext_array[:faces_id][i],
                   0
          ]
          edit.push(ope)
        end
      end
      for i in 0...len_s do
        pre = @servertext_array[:faces_id].index(@servershadow_array[:faces_id][i])
        unless pre
          ope = [  "face_remove",
                   @servershadow_array[:faces_id][i],
                   0
          ]
          edit.push(ope)
        end
      end




      len_t = @servertext_array[:vertices_id].length
      len_s = @servershadow_array[:vertices_id].length
      for i in 0...len_t do
        pre = @servershadow_array[:vertices_id].index(@servertext_array[:vertices_id][i])
        if pre
          if @servertext_array[:vertices][i * 3] != @servershadow_array[:vertices][pre * 3] || @servertext_array[:vertices][i * 3 + 1] != @servershadow_array[:vertices][pre * 3 + 1] || @servertext_array[:vertices][i * 3 + 2] != @servershadow_array[:vertices][pre * 3 + 2]
            ope = [  "vertex_update",
                     @servertext_array[:vertices_id][i],
                     [
                       @servertext_array[:vertices][i * 3],
                       @servertext_array[:vertices][i * 3 + 1],
                       @servertext_array[:vertices][i * 3 + 2]
                     ]
            ]
            edit.push(ope)
          end
        else
          ope = [  "vertex_add",
                   @servertext_array[:vertices_id][i],
                   [
                     @servertext_array[:vertices][i * 3],
                     @servertext_array[:vertices][i * 3 + 1],
                     @servertext_array[:vertices][i * 3 + 2]
                   ]
          ]
          edit.push(ope)
        end
      end
      for i in 0...len_s do
        pre = @servertext_array[:vertices_id].index(@servershadow_array[:vertices_id][i])
        unless pre
          ope = [  "vertex_remove",
                   @servershadow_array[:vertices_id][i],
                   0
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

        if ope == 'mesh_add'
          @mesh = scene.meshes.create(
            :uuid => id
          )
          @mesh.save
        elsif ope == 'mesh_remove'
          mesh = scene.meshes.find_by(:uuid => id)
          mesh.destroy
        elsif ope == 'mesh_update'
          mesh = scene.meshes.find_by(:uuid => id)
          faces = scene.faces.where(:uuid => data[0])
          faces.each do |face|
            @face = scene.faces.create(
              :uuid => face.uuid,
              :mesh_id => mesh.id
            )
            @face.save
          end

        elsif ope == 'face_add'
          @face = scene.faces.create(
            :uuid => id
          )
          @face.save
        elsif ope == 'face_remove'
          faces = scene.faces.where(:uuid => id)
          faces.each do |face|
            face.destroy
          end
        elsif ope == 'face_update'
          face = scene.faces.find_by(:uuid => id)
          vertices = scene.vertices.where(:uuid => data[0])
          vertices.each do |vertex|
            @vertex = scene.vertices.create(
              :uuid => vertex.uuid,
              :component => vertex.component,
              :data => vertex.data,
              :face_id => face.id
            )
            # if tmp&.pointer
            #   if tmp.pointer == vertex.uuid
            #     vertex.pointer = tmp.uuid
            #   else
            #     vertex.pointer = tmp.pointer
            #     changes = face.vertices.where(:uuid => tmp.uuid)
            #     changes.each do |change|
            #       change.pointer = vertex.uuid
            #       change.save
            #     end
            #   end
            # else
            #   vertex.pointer = vertex.uuid
            #   tmp = vertex
            # end
            @vertex.save
          end
        elsif ope == 'vertex_add'
          vertex_uuid = id
          @vertex1 = scene.vertices.create(
            :uuid => vertex_uuid,
            :component => "x",
            :data => data[0]
          )
          @vertex2 = scene.vertices.create(
            :uuid => vertex_uuid,
            :component => "y",
            :data => data[1]
          )
          @vertex3 = scene.vertices.create(
            :uuid => vertex_uuid,
            :component => "z",
            :data => data[2]
          )
          @vertex1.save
          @vertex2.save
          @vertex3.save
        elsif ope == 'vertex_remove'
          scene.vertices.each do |vertex|
            if vertex.uuid == id
              vertex.destroy
            end
          end
        elsif ope == 'vertex_update'
          scene.vertices.each do |vertex|
            if vertex.uuid == id
              if vertex.component == "x"
                vertex.data = data[0]
              elsif vertex.component == "y"
                vertex.data = data[1]
              elsif vertex.component == "z"
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
      servershadow = room.scenes.find_by(:aff => user.id)
      servertext = room.scenes.find_by(:aff => 0)

      @servertext_array = {
        :mesh => [],
        :meshes_id => [],
        :faces => [],
        :faces_id => [],
        :vertices => [],
        :vertices_id => []
      }

      servertext.meshes.each do |mesh|
        @servertext_array[:meshes_id].push(mesh.uuid)
        array = []
        mesh.faces.each do |face|
          unless array.index(face.uuid)
            array.push(face.uuid)
          end
        end
        @servertext_array[:mesh].push(array)
      end
      servertext.faces.each do |face|
        @servertext_array[:faces_id].push(face.uuid)
        array = []
        face.vertices.each do |vertex|
          unless array.index(vertex.uuid)
            array.push(vertex.uuid)
          end
        end
        @servertext_array[:faces].push(array)
      end
      servertext.vertices.each do |vertex|
        unless @servertext_array[:vertices_id].index(vertex.uuid)
          @servertext_array[:vertices_id].push(vertex.uuid)
          vertex_x = servertext.vertices.find_by(:uuid => vertex.uuid, :component => "x")
          vertex_y = servertext.vertices.find_by(:uuid => vertex.uuid, :component => "y")
          vertex_z = servertext.vertices.find_by(:uuid => vertex.uuid, :component => "z")
          @servertext_array[:vertices].push(vertex_x.data,vertex_y.data,vertex_z.data)
        end
      end


      deletescene(servershadow)

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
        unless face.mesh_id
          @face = @scene.faces.create(
            :uuid => face.uuid
          )
        end
      end
      servertext.vertices.each do |vertex|
        unless vertex.face_id
          @vertex = @scene.vertices.create(
            :uuid => vertex.uuid,
            :component=> vertex.component,
            :data => vertex.data
          )
        end
      end

      for i in 0...@servertext_array[:meshes_id].length do
        array = @servertext_array[:mesh][i]
        array.each do |uuid|
          mesh = @scene.meshes.find_by(:uuid => @servertext_array[:meshes_id][i])
          @face = @scene.faces.find_by(:uuid => uuid)
          @face.mesh_id = mesh.id
          @face.save
        end
      end

      for i in 0...@servertext_array[:faces_id].length do
        array = @servertext_array[:faces][i]
        array.each do |uuid|
          idx = @servertext_array[:vertices_id].index(uuid)
          if idx
            face = @scene.faces.find_by(:uuid => @servertext_array[:faces_id][i])
            @vertex = face.vertices.create(
              :uuid => uuid,
              :component=> "x",
              :data => @servertext_array[:vertices][idx],
              :scene_id => @scene.id
            )
            @vertex = face.vertices.create(
              :uuid => uuid,
              :component=> "y",
              :data => @servertext_array[:vertices][idx],
              :scene_id => @scene.id
            )
            @vertex = face.vertices.create(
              :uuid => uuid,
              :component=> "z",
              :data => @servertext_array[:vertices][idx],
              :scene_id => @scene.id
            )
          end
        end
      end
    end

    def deletescene(scene)
      if scene
        scene.meshes.each do |mesh|
          if mesh
            mesh.destroy
          end
        end
        scene.faces.each do |face|
          if face
            face.destroy
          end
        end
        scene.vertices.each do |vertex|
          if vertex
            vertex.destroy
          end
        end
        scene.destroy
      end
    end
end
