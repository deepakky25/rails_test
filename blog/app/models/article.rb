class Article < ActiveRecord::Base
  has_many :comments

  before_validation :generate_slug
  before_validation :article_params_updation
 
  validates_presence_of :title, :text, :picture, :user_id, :slug, :imgname 
  validates :slug, uniqueness: true
  validates :title, length: { minimum: 6 }
  validates :text, length: { minimum: 10 }

  after_commit :mail_notification, on: :create


  def mail_notification
    Resque.enqueue(DeliverLaterPost, self.id)
  end

  def generate_slug
    return unless slug.nil?
    self.slug = title.downcase.gsub(/[^0-9A-Za-z ]/, '')
    max_titleslug = Article.select([:slug]).where("slug like ?", "#{title.gsub(' ','-')}%").order(id: :desc).limit(1)[0]
    if max_titleslug
      if max_titleslug[:slug].gsub!(/[^0-9]/, '') != ''
        max_titleslug = max_titleslug[:slug].to_i + 1
        self.slug = slug.gsub(' ','-') + max_titleslug.to_s
      else
        self.slug = slug.gsub(' ','-') + '1'
      end
    else
      self.slug = slug.gsub(' ','-')
    end
  end

  def article_params_updation
    if not picture and id
      self.picture = Article.find(id).picture
      self.imgname = Article.find(id).imgname
    end
  end

  def image_upload(image, image_name)
    byebug
    File.open(Rails.root.join('app/assets', 'article_images', image_name), 'wb') do |f|
      f.write(image.read)
    end
  end
end
