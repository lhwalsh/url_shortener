class SitesController < ApplicationController
  BASE_URL = 'http://short.est/'.freeze

  def encode
    site = Site.find_or_create_by!(name: url)

    render json: BASE_URL + encode_id(site.id)
  end

  def decode
    return invalid_url_error unless url.start_with?(BASE_URL)

    id = decode_url(url.delete_prefix(BASE_URL))
    site = Site.find(id)

    render json: site.name
  end

  private

  def encode_id(id)
    encoded_id = ''
    counter = id
    total_chars = valid_chars.count

    loop do
      encoded_id += valid_chars[counter % total_chars]
      counter = counter / total_chars
      break if counter < total_chars
    end

    encoded_id += valid_chars[counter % total_chars]
    encoded_id
  end

  def invalid_url_error
    render json: "Encoded URL must start with #{BASE_URL}", status: :bad_request
  end

  def decode_url(url)
    decode_chars(url).inject { |sum, num| sum * 62 + num }
  end

  def decode_chars(url)
    url.reverse.split('').map { |char| valid_chars.find_index(char) }
  end

  def valid_chars
    @valid_chars ||= ['a'..'z', 'A'..'Z', '0'..'9'].flat_map(&:to_a)
  end

  def url
    params.require(:url)
  end
end
