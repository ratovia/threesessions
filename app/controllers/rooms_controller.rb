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
    shadow(@room, @user)
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
      num = [user,type,last,SecureRandom.base64(3)].join('')
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

      @face = @mesh.faces.create(
        :uuid => grant(0,1)
      )
      @face.save

      vertex_uuid = grant(0,0)
      @vertex1 = @face.vertices.create(
        :uuid => vertex_uuid,
        :axis => "x",
        :data => 10
      )
      @vertex2 = @face.vertices.create(
        :uuid => vertex_uuid,
        :axis => "y",
        :data => 10
      )
      @vertex3 = @face.vertices.create(
        :uuid => vertex_uuid,
        :axis => "z",
        :data => 10
      )

      @vertex1.save
      @vertex2.save
      @vertex3.save
    end

    def diff(room,user)
      # serverTextとserverShadowのデータの差分
      edit = []
      @servertext = {
        :meshes_id => [],
        :faces_id => [],
        :vertices_id => []
      }

      @servershadow = {
        :meshes_id => [],
        :faces_id => [],
        :vertices_id => []
      }
      systemscene = Scene.find_by(:room_id => room.id, :aff => 0)
      userscene = Scene.find_by(:room_id => room.id, :aff => user.id)

      systemscene.meshes.each do |mesh|
        @servertext[:meshes_id].push(mesh.uuid)
        mesh.faces.each do |face|
          @servertext[:faces_id].push(face.uuid)
          face.vertices.each do |vertex|
            @servertext[:vertices_id].push(vertex.uuid)

          end
        end
      end

      userscene.meshes.each do |mesh|
        @servershadow[:meshes_id].push(mesh.uuid)
        mesh.faces.each do |face|
          @servershadow[:faces_id].push(face.uuid)
          face.vertices.each do |vertex|
            @servershadow[:vertices_id].push(vertex.uuid)
          end
        end
      end



      len_t = @servertext[:meshes_id].length
      len_s = @servershadow[:meshes_id].length
      for i in 0...len_t do
        pre = @servershadow[:meshes_id].index(@servertext[:meshes_id][i])
        unless pre
          ope = [  "mesh",
                   @servertext[:meshes_id][i],
                   0
          ]
          edit.push(ope)
        end
      end

      for i in 0...len_s do
        pre = @servertext[:meshes_id].index(@servershadow[:meshes_id][i])
        unless pre
          ope = [  "demesh",
                   @servershadow[:meshes_id][i],
                   0
          ]
          edit.push(ope)
        end
      end

      len_t = @servertext[:faces_id].length
      len_s = @servershadow[:faces_id].length
      for i in 0...len_t do
        pre = @servershadow[:faces_id].index(@servertext[:faces_id][i])
        unless pre
          face_array = []
          systemscene.meshes.each do |mesh|
            mesh.faces.each do |face|
              face.vertices.each do |vertex|
                if vertex.axis == "x" && vertex.face_id == face.id
                  face_array.push(vertex.uuid)
                end
              end
            end
          end
          ope = [  "face",
                   @servertext[:faces_id][i],
                   face_array
          ]
          edit.push(ope)
        end
      end

      for i in 0...len_s do
        pre = @servertext[:faces_id].index(@servershadow[:faces_id][i])
        unless pre
          ope = [  "deface",
                   @servershadow[:faces_id][i],
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

      len_t = @servertext[:vertices_id].length
      len_s = @servershadow[:vertices_id].length
      for i in 0...len_t do
        pre = @servershadow[:vertices_id].index(@servertext[:vertices_id][i])
        systemscene.meshes.each do |mesh|
          mesh.faces.each do |face|
            face.vertices.each do |vertex|
              if vertex.uuid == @servertext[:vertices_id][i]
                if vertex.axis == "x"
                  text[:x] = vertex.data
                elsif vertex.axis == "y"
                  text[:y] = vertex.data
                elsif vertex.axis == "z"
                  text[:z] = vertex.data
                end
              end
            end
          end
        end

        userscene.meshes.each do |mesh|
          mesh.faces.each do |face|
            face.vertices.each do |vertex|
              if vertex.uuid == @servershadow[:vertices_id][i]
                if vertex.axis == "x"
                  shado[:x] = vertex.data
                elsif vertex.axis == "y"
                  shado[:y] = vertex.data
                elsif vertex.axis == "z"
                  shado[:z] = vertex.data
                end
              end
            end
          end
        end
        if pre
          if text[:x] != shado[:x] || text[:y] != shado[:y] || text[:z] != shado[:z]
            ope = [  "move",
                     @servertext[:vertices_id][i],
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
                   @servertext[:vertices_id][i],
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

        systemscene.meshes.each do |mesh|
          mesh.faces.each do |face|
            face.vertices.each do |vertex|
              if vertex.uuid == @servertext[:vertices_id][i]
                if vertex.axis == "x"
                  text[:x] = vertex.data
                elsif vertex.axis == "y"
                  text[:y] = vertex.data
                elsif vertex.axis == "z"
                  text[:z] = vertex.data
                end
              end
            end
          end
        end

        userscene.meshes.each do |mesh|
          mesh.faces.each do |face|
            face.vertices.each do |vertex|
              if vertex.uuid == @servershadow[:vertices_id][i]
                if vertex.axis == "x"
                  shado[:x] = vertex.data
                elsif vertex.axis == "y"
                  shado[:y] = vertex.data
                elsif vertex.axis == "z"
                  shado[:z] = vertex.data
                end
              end
            end
          end
        end


        pre = @servertext[:vertices_id].index(@servershadow[:vertices_id][i])
        unless pre
          ope = [  "remove",
                   @servershadow[:vertices_id][i],
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
          scene.meshes.each do |mesh|
            mesh.faces.each do |face|
              vertex_uuid = id
              @vertex1 = face.vertices.create(
                :uuid => vertex_uuid,
                :axis => "x",
                :data => data[0]
              )
              @vertex2 = face.vertices.create(
                :uuid => vertex_uuid,
                :axis => "y",
                :data => data[1]
              )
              @vertex3 = face.vertices.create(
                :uuid => vertex_uuid,
                :axis => "z",
                :data => data[2]
              )
              @vertex1.save
              @vertex2.save
              @vertex3.save
            end
          end
        elsif ope == 'remove'
          scene.meshes.each do |mesh|
            mesh.faces.each do |face|
              face.vertices.each do |vertex|
                if vertex.uuid == id
                  vertex.destroy
                end
              end
            end
          end
        elsif ope == 'face'
          scene.meshes.each do |mesh|
            @face = mesh.faces.create(
              :uuid => id
            )
            @face.save
            @vertex_x = Vertex.find_by(:uuid => data[0],:axis => "x").data
            @vertex_y = Vertex.find_by(:uuid => data[1],:axis => "y").data
            @vertex_z = Vertex.find_by(:uuid => data[2],:axis => "z").data
            @vertex1 = @face.vertices.create(
              :uuid => data[0],
              :axis => "x",
              :data => @vertex_x
            )
            @vertex2 = @face.vertices.create(
              :uuid => @data[1],
              :axis => "y",
              :data => @vertex_y
            )
            @vertex3 = @face.vertices.create(
              :uuid => data[2],
              :axis => "z",
              :data => @vertex_z
            )
            @vertex1.save
            @vertex2.save
            @vertex3.save
          end
        elsif ope == 'deface'
          scene.meshes.each do |mesh|
            mesh.faces.each do |face|
              if face.uuid == id
                face.destory
              end
            end
          end
        elsif ope == 'move'
          scene.meshes.each do |mesh|
            mesh.faces.each do |face|
              face.vertices.each do |vertex|
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
      end
    end

    def makeshadow(room,user)
      @scene = room.scenes.create(
        :aff => user.id
      )
      @scene.save
    end

    def shadow(room, user)
      # すでにあるserverShadowを削除
      servershadow = room.scenes.find_by(:aff => user.id)
      if servershadow
        servershadow.meshes.each do |mesh|
          mesh.faces.each do |face|
            face.vertices.each do |vertex|
              if vertex
                vertex.destroy
              end
            end
            if face
              face.destroy
            end
          end
          if mesh
            mesh.destroy
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
        mesh.faces.each do |face|
          @face = @mesh.faces.create(
            :uuid => face.uuid
          )
          @face.save
          face.vertices.each do |vertex|
            @vertex = @face.vertices.create(
              :uuid => vertex.uuid,
              :axis => vertex.axis,
              :data => vertex.data
            )
            @vertex.save
          end
        end
      end
    end
end
