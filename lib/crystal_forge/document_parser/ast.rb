module CrystalForge
  class DocumentParser
    ##
    # Bridge to understanding different API specification documents.  This
    # class is meant to be extended for each specification that should be
    # parsed by Crystal Forge.
    class AST
      ##
      # Error raised when AST cannot parse a document
      UnkownFormat = Class.new(Exception)

      class << self
        ##
        # An array of all AST subclasses available
        def asts
          @asts ||= []
        end

        ##
        # Meant to be implemented by subclases, this method should expect
        # to receive a string and potentially future named arguments.  This
        # method needs to analyze given document and return true if it `looks`
        # like it can parse it
        def understands?(_api_string, _opts = {})
          fail NotImplementedError,
               [
                 'Needs to return true or false with a given api_string, ',
                 'should also support a potential options set'
               ].join
        end

        ##
        # Delegates to the first found ast that understands it
        def parse(string)
          ast = asts.find { |a| a.understands? string }
          fail UnkownFormat if ast.nil?
          ast.new(string)
        end

        private

        def inherited(klass)
          @asts ||= []
          @asts << klass
        end
      end
    end
  end
end
