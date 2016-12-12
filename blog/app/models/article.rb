class Article < ActiveRecord::Base
  has_many :comments
  has_many :images
  accepts_nested_attributes_for :images, :reject_if => lambda { |a| a[:filename].blank?}, :allow_destroy => true

  before_validation :generate_slug
  before_validation :article_params_updation
 
  validates_presence_of :title, :text, :user_id, :slug 
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
    if not images[0].filename and id
      self.images[0].filename = Article.find(id).images[0].filename
    end
  end

  def image_upload(image)
    if image
      Dir.mkdir(Rails.root + "app/assets/article_#{self.id.to_s}") unless File.exists?(Rails.root + "app/assets/article_#{self.id.to_s}")
      File.open(Rails.root.join('app/assets/', 'article_'+self.id.to_s, image.original_filename), 'wb') do |f|
        f.write(image.read)
      end
    end
  end
end
