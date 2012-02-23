module Admin

  def assign_position(position_file)
    users = {}
    usernames = YAML.load(File.open(position_file))
    usernames.each_with_index do |username, position|
      users[username] = position + 1
    end

    Account.all.each do |user|
      user.presentation_position = users[user.username]
      user.save!
    end
  end

  def assign_assistant(assistant_file)
    assistant = YAML.load(File.open(assistant_file))
    assistant.each do |pres, assist|
      if pres == assist
        puts "User #{pres} has the himself/herself as assistant, not updating"
        return
      end

      presenter = Account.where('username = ?', pres).first
      unless presenter
        puts "User: #{pres} does not exist"
        return
      end

      if assist
        # Update assistant
        assistant = Account.where('username = ?', assist).first
        unless assistant
          puts "User: #{assist} does not exist"
          return
        end
        presenter.assistant = assistant
        presenter.save!
      else
        # Delete assistant
        puts "Deleting assistant for user #{pres}"
        presenter.assistant = nil
        presenter.save!
      end

    end
  end
end
