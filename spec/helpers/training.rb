module Training
  def Training.text_for(name)
    name = name.to_sym
    path = File.join(File.dirname(__FILE__),'..','training',"#{name}.txt")

    return File.read(path)
  end
end
