namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") { %x(rails db:drop) }
      show_spinner("Criando BD...") { %x(rails db:create) }
      show_spinner("Migrando BD..."){ %x(rails db:migrate) }
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)

    else
      puts "Você não está em ambiente de desenvolvimento!"
    end
  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do
      coins = [
                  { description: "Bitcoin",
                    acronym: "BTC",
                    url_image: "https://image.shutterstock.com/image-vector/bitcoin-icon-vector-sign-payment-260nw-792341014.jpg",
                    mining_type: MiningType.find_by(acronym: 'PoW')
                  },
                  { description: "Ethereum",
                    acronym: "ETH",
                    url_image: "https://img1.gratispng.com/20180330/gkq/kisspng-ethereum-bitcoin-cryptocurrency-logo-tether-bitcoin-5abdfe01865749.6048300215224007695503.jpg",
                    mining_type: MiningType.all.sample
                  },
                  { description: "Dash",
                    acronym: "DASH",
                    url_image: "https://image.shutterstock.com/image-photo/image-260nw-779917273.jpg",
                    mining_type: MiningType.all.sample
                  },
                  { description: "Iota",
                    acronym: "IOT",
                    url_image: "https://faviconer.net/preloaders/871/Iota%20logo%20spinning.jpg",
                    mining_type: MiningType.all.sample
                  }
                  
              ]
      coins.each do |coin|
         Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastra os tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando tipos de mineração...") do
      mining_types = [
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"}
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end


  def show_spinner(msg_start, msg_end = "Concluido!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
