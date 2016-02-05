defmodule Bot.Model do

  defmodule CarousellProduct do
    defstruct title: nil, price: nil, id: nil, time_created: nil,
    comments_count: nil, currency_symbol: nil, description: nil,
    like_status: nil, likes_count: nil, location: nil, location_address: nil,
    location_name: nil, marketplace: nil, price: nil, price_formatted: nil,
    primary_photo: nil, primary_photo_url: nil, seller: nil, status: nil,
    time_created: nil, title: nil, user_state: nil, utc_last_liked: nil

    @type t :: %CarousellProduct{
      title: binary, price: binary, id: integer, time_created: binary,
      comments_count: binary, currency_symbol: binary, description: binary,
      like_status: boolean, likes_count: binary,
      location: CarousellLocation.t, location_address: binary,
      location_name: binary,
      marketplace: %{
        country: %{city_count: integer, code: binary, id: integer, name: binary},
        id: integer, location: CarousellLocation.t, name: binary
      },
      price_formatted: binary, primary_photo: binary, primary_photo_url: binary,
      seller: CarousellUser.t, status: binary, user_state: integer, utc_last_liked: binary
    }
  end

  defmodule CarousellLocation do
    defstruct latitude: nil, longitude: nil
    @type t :: %CarousellLocation{latitude: float, longitude: float}
  end

  defmodule CarousellUser do
    defstruct first_name: nil, id: nil, last_name: nil, profile: nil,
    username: nil
    @type t :: %CarousellUser{first_name: binary, id: integer, last_name: binary,
    profile: CarousellProfile.t, username: binary}
  end

  defmodule CarousellProfile do
    defstruct image: nil, image_url: nil, is_email_verified: nil,
    is_facebook_verified: nil, is_gplus_verified: nil, verification_type: nil
    @type t :: %CarousellProfile{image: binary, image_url: binary,
    is_email_verified: boolean, is_facebook_verified: boolean,
    is_gplus_verified: boolean, verification_type: binary}
  end
  
end
