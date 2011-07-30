DbdNotebook.controllers :posts do     
  
  before(:pages, :tag, :type) do
    if params[:page].to_i       
      @pagenum = params[:page].to_i
      halt 403, 'Malforem pagenum' unless @pagenum.is_a?(Numeric)  
    end
  end  
  
  # Options
  before(:index, :pages) do
    @options = {:order => 'updated_at desc'}            
    @options[:status] = :public
  end
  
  get :index, :map => "/", :provides => [:html, :rss] do   
    @pager = Paginator.new(Post.count, 15) do |offset, per_page|   
      @options[:skip]   = offset 
      @options[:limit]  = per_page
      Post.all(@options)  
    end
    @posts = @pager.page(0)  
    render "posts/index" 
  end  
  
  get :show, :map => "/:slug/" do   
    slug = params[:slug].match(/^([A-Za-z0-9-]+)/i).to_s  
    if !slug.empty?
      @post = Post.find_by_slug(:slug => slug)   
      not_found unless @post               
      @comments = Comment.threaded_with_field(@post)   
      render "#{@post.class.to_s.downcase.pluralize}/#{@post.class.to_s.downcase}"    
    end     
  end
  
  get :pages, :map => "/(page)(:page)" do   
    @pager = Paginator.new(Post.count, 15) do |offset, per_page|
      Post.all(@options)  
    end
    @posts = @pager.page(@pagenum)    
    render "posts/index" 
  end
  
  # Finds post with a specific tag.
  # We use the paginator gem; although it requires more effort to setup its worth it for the control it offers.
  # Increased control means we can accomplish things like SEF paginaiton urls.
  # If we surrender control to paginators for our urls then where does it stop?
  # Soon they'll be paginating humans, can you imagine clicking next before peeing? I cant. That is a wrold I refuse to live in.
  get :tag, :map => '/tags(/:tag)(/page/:page)' do
    if params[:tag] != nil     
      tag = params[:tag].match(/^([A-Za-z0-9-]+)/i).to_s 
      @pager = Paginator.new(Post.count, 15) do |offset, per_page|  
        Post.all(:skip => offset, :limit => per_page, :order => 'updated_at desc', :tags => tag)
      end    
      @posts = @pager.page(@pagenum)
    end 
    render 'posts/tags'
  end 
  
  # Finds posts pf a specific type.        
  get :type, :map => '/type(/:type)(/page/:page)' do      
    if params[:type] == nil
       params[:type] = 'All'
    end     
    if params[:type] == 'All' 
      @type =  {:$exists => true}   
    else 
      @type = params[:type].match(/^([A-Za-z0-9-]+)/i).to_s.downcase.capitalize
    end      
  
    # In our view will pass this object to menu builder helper.
    @typemenu = [  
        { 'name' => 'All', 'class' => 'all', 'url' => '/type/All', 'text' => 'All'},
        { 'name' => 'Blog', 'class' => 'blog', 'url' => '/type/Blog', 'text' => 'Blogs'},    
        { 'name' => 'Note', 'class' => 'note', 'url' => '/type/Note', 'text' => 'Notes'},
        { 'name' => 'Preview', 'class' => 'preview', 'url' => '/type/Preview', 'text' => 'Previews'},   
        { 'name' => 'Quote', 'class' => 'quote', 'url' => '/type/Quote', 'text' => 'Quotes'}, 
        { 'name' => 'Shortbit', 'class' => 'shortbit last', 'url' => '/type/Shortbit', 'text' => 'Shortbits'} 
      ]  
      
    pager = Paginator.new(Post.count, 15) do |offset, per_page|  
      Post.all(:skip => offset, :limit => per_page, :order => 'updated_at desc', :_type => @type)
    end    
    @posts = pager.page(@pagenum)
    render 'posts/type'   
  end    
  
  get :rss, :map => "/feeds" do
    content_type :rss, :charset => "UTF-8"
    @posts = Post.all(:order => 'updated_at desc', :status => :public) 
    render 'feeds/rss'
  end
  
  get :bydate, :map =>"/date/2010/:month" do
    render "posts/bymonth"
  end     
end