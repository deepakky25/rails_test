class UploadImage
  @queue = :upload_image

  def self.perform(pic)
    image = pic[:picture]
    File.open(Rails.root.join('app/assets', 'article_images', image.original_filename), 'wb') do |f|
      f.write(image.read)
    end
  end

end
