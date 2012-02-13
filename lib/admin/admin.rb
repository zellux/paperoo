module Admin

  def assign_position(position_file)
    accounts = YAML.load(File.open(position_file))
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
