class RoomsController < ApplicationController
  protect_from_forgery :only => ["create"]
  def join
    @room = Room.find(params[:room_id])
    @user = User.find(params[:users_id])
    shadow(@room, @user)
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
    # patch
    patch(params[:edit])
    # diff
    data = diff(serverText,serverShadow)
    # copy
    shadow(@room, @user)
    # render
    render json: data
  end

  def aaa
    grant("system",2)
  end

  private

    def grant(user,type)
      num = [user,type,SecureRandom.uuid].join('')
      return num
    end

    def seed(room)
      @scene = room.scenes.create(
        :aff => 0
      )
      @scene.save

      @mesh = @scene.meshes.create(
        :uuid => grant("system",2),
      )
      @mesh.save

      @face = @mesh.faces.create(
        :uuid => grant("system",1)
      )
      @face.save
      @vertex1 = @face.vertices.create(
        :uuid => grant("system",0),
        :axis => "x",
        :data => 10
      )
      @vertex2 = @face.vertices.create(
        :uuid => grant("system",0),
        :axis => "y",
        :data => 10
      )
      @vertex3 = @face.vertices.create(
        :uuid => grant("system",0),
        :axis => "z",
        :data => 10
      )

      @vertex1.save
      @vertex2.save
      @vertex3.save
    end

    def diff(text,shadow)
      # serverTextとserverShadowのデータの差分
      edit = []
      len_t = text.vertices_id.length
      len_s = shadow.vertices_id.length
      for i in 0..len_t do
        pre = shadow.vertices_id.index
        if pre >= 0
          if shadow.vertices[pre * 3] != text.vertices[i * 3] || shadow.vertices[pre * 3 + 1] != text.vertices[i * 3 + 1] || shadow.vertices[pre * 3 + 2] != text.vertices[i * 3 + 2]
            ope = [ 'move',
                    shadow.vertices[pre],
                    [ text.vertices[i * 3],
                      text.veritces[i * 3 + 1],
                      text.vertices[i * 3 + 2]
                    ]
            ]
            edit.push(ope)
          end
        else
          ope = [  'add',
                   text.vertices_id[i],
                   [  text.vertices[i * 3],
                      text.vertices[i * 3 + 1],
                      text.vertices[i * 3 + 2]
                   ]
          ]
          edit.push(ope)
        end
      end
      for i in 0..len_s do
        pre = text.vertices_id.index(shadow.vertices_id[i]);
        if pre < 0
          ope = [  'remove',
                   shadow.vertices_id[i],
                   [  shadow.vertices[i * 3],
                      shadow.vertices[i * 3 + 1],
                      shadow.vertices[i * 3 + 2]
                   ]
          ]
          edit.push(ope)
        end
      end
      len_t = text.faces_id.length
      len_s = shadow.faces_id.length

      for i in len_t do
        pre = shadow.faces_id.index(text.faces_id[i])
        if pre < 0
          ope = [  'face',
                   text.faces_id[i],
                   text.faces[i]
          ]
          edit.push(ope)
        end
      end

      for i in len_s do
        pre = text.faces_id.index(shadow.faces_id[i])
        if pre < 0
          ope = [  'deface',
                   shadow.faces_id[i],
                   shadow.faces[i]
          ]
          edit.push(ope)
        end
      end
      edit
    end

    def patch(edit)
      # serverTextとserverShadowの値の書き換え
      for i in 0..edit.length
        ope = edit[i][0]
        id = edit[i][1]
        data = edit[i][2]
        if ope == 'add'
          unless has_id(serverText,id,'vertex')
            serverText.vertices_id.push(id)
            serverText.vertices.push(data[0])
            serverText.vertices.push(data[1])
            serverText.vertices.push(data[2])
          end

          unless has_id(serverShadow,id, 'vertex')
            serverShadow.vertices_id.push(id)
            serverShadow.vertices.push(data[0])
            serverShadow.vertices.push(data[1])
            serverShadow.vertices.push(data[2])
          end
        elsif ope == 'remove'
          if has_id(serverText,id,'vertex')
            serverText.vertices_id.splice(serverText.vertices_id.index(id),1)
            serverText.vertices.splice(serverText.vertices.index(data[0],3))
          end

          if has_id(serverShadow,id,'vertex')
            serverShadow.vertices_id.splice(serverShadow.vertices_id.index(id),1)
            serverShadow.vertices.splice(serverShadow.vertices.index(data[0],3))
          end
        elsif ope == 'face'
          unless has_id(serverText,id,'face')
            serverText.faces_id.push(id)
            array = []
            for j in 0..data.length
              array.push(data[j])
            end
            if array.length > 0
              serverText.faces.push(array)
            end
          end

          unless has_id(serverShadow,id,'face')
            serverShadow.faces_id.push(id)
            array = []
            for j in 0..data.length
              array.push(data[j])
            end
            if array.length > 0
              serverShadow.faces.push(array)
            end
          end
        elsif ope == 'deface'
          if has_id(serverText,id,'face')
            serverText.faces.splice(serverText.faces_id.index(id),1)
          end
          if has_id(serverShadow,id,'face')
            serverShadow.faces.splice(serverShadow.faces_id.index(id),1)
          end
        elsif ope == 'move'
          for j in 0..data.length do
            serverText.vertices[serverText.vertices_id.index(id) + j] = data[j]
          end
        end
      end
    end

    def has_id(object,id,type)
      if type == 'face'
        if object.faces_id.index(id) >= 0
          return true
        else
          return false
        end
      elsif type == 'vertex'
        if object.vertices_id.index(id) >= 0
          return true
        else
          return false
        end
      end
    end

    def shadow(room, user)
      # すでにあるserverShadowを削除
      servershadow = room.scenes.find_by(:aff => user.id)
      if servershadow
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
