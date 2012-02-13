module Admin

  def assign_position(position_file)
    accounts = YAML.load(File.open(Rails.root + position_file))
    accounts.each do |username, position|
      acc = Account.where('username = ?', username).first
      unless acc
        puts "User: #{username} does not exist"
        return
      end

      acc.presentation_position = position.to_i
      acc.save!
      end
    end

  def assign_assistant(assistant_file)
    assistant = YAML.load(File.open(Rails.root + assistant_file))
    assistant.each do |presenter, assistant|
      presenter = Account.where('username = ?', presenter).first
      unless presenter
        puts "User: #{presenter} does not exist"
        return
      end

      assistant = Account.where('username = ?', assistant).first
      unless assistant
        puts "User: #{assistant} does not exist"
        return
      end

      presenter.assistant = assistant
      presenter.save!
    end
  end
end
