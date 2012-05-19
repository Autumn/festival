require 'sinatra'
require 'erb'
require 'sqlite3'

db = SQLite3::Database.new("festival.db")

get '/' do
    erb :index , :locals => {:db => db}
end

get '/:id' do
    is_thread = db.execute("select 1 from threads where id = #{params[:id]}")
    if is_thread[0] != nil
        thread_view = "select id,txt from posts where id = #{params[:id]} union select posts.id,posts.txt from posts join replies on replies.reply where replies.thread = #{params[:id]} and posts.id = replies.reply"
        db.execute(thread_view).to_s
    else 
        "no thread"
    end
end

post '/post' do
    if params[:thread] == nil
        text = params[:post]
        db.transaction do |d|
            id = d.execute("select max(id) from posts")[0][0].to_i + 1
            d.execute("insert into threads values(#{id})")
            d.execute("insert into posts values(#{id}, null, '#{text}')")
        end
        redirect '/'
    else
        thread = params[:thread]
        text = params[:post]
        db.transaction do |d|
            id = d.execute("select max(id) from posts")
            id = id[0][0].to_i + 1
            d.execute("insert into posts values(#{id}, null, '#{text}')")
            d.execute("insert into replies values(#{thread.to_i}, #{id})")
        end
        redirect '/'
    end
end

get '/:ident' do
    erb :post, :locals => {:id => params[:ident]}
end
