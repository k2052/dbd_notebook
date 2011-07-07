class Post
  include MongoMapper::Document
  include MongoMapperExt::Slugizer 
  plugin MongoMapper::Plugins::Timestamps 
  
  # Keys
  key :status,        String
  key :tags,          Array
  key :title,         String
  key :comment_count, Integer, :default => 0
  timestamps!   
  
  # Key Settings
  slug_key :title, :unique => true   
  
  # Associations
  many :comments, :dependent => :destroy      
  
  ##
  # Getter and Setter Methods 
  #                   
  
  # Generates the slug   
  def generate_slug
    return false if self[self.class.slug_key].blank?
    max_length = self.class.slug_options[:max_length]
    min_length = self.class.slug_options[:min_length] || 0

    slug = self[self.class.slug_key].parameterize.to_s
    slug = slug[0, max_length] if max_length

    if slug.size < min_length
      slug = nil
    end

    if slug && !self.class.slug_options[:unique]
      self.slug = slug
    else
      self.slug = slug
    end
  end
 
  # Called Saving The Tags
  def tags=(t)
    if t.kind_of?(String)
      t = t.downcase.split(",").join(" ").split(" ").uniq
    end
    self[:tags] = t
  end
   
  # Called When Displaying Tags
  def tags()   
    self[:tags].join(",")  
  end   
   
  ##
  # Collection Methods
  #                   
   
  # Generates A Tag Cloud Using Map Reduce.
  # Returns nested letter e.g tags = { :b => ["barry". "ben", "bob"]}
  def self.tag_cloud
    m = <<-JS
        function() {
            if (!this.tags) {
                return;
            }

            for (index in this.tags) {
                emit(this.tags[index], 1);
            }
        }  
      JS
    r = <<-JS
        function(previous, current) {
            var count = 0;

            for (index in current) {
                count += current[index];
            }

            return count;
        }
      JS
    results = self.collection.map_reduce(m,r, :query => { :created_at => {'$gt' => Time.gm(2010,"jan",1) } })
    results = results.find().to_a
    return results
  end
end