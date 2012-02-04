module Jepeto
  # TODO: Add some documentation here


  class InvalidQueryTypeError < ArgumentError
  end

  class InvalidNameOrTitleError < ArgumentError
  end

  class InvalidDateFormatError < ArgumentError
  end

  class InvalidLayoutError < ArgumentError
  end

  class InvalidBooleanTypeError < TypeError
  end

  class InvalidFileExtensionError < ArgumentError
  end

  class EmptyOrNilTitleError < ArgumentError
  end

  class PostDirectoryNotWritableError < StandardError
  end

  class PostFileAlreadyExistsError < NameError
  end
end