# encoding: utf-8

module Sparsify
  def self.sparse source
    result = {}
    source.each do |k,v|
      puts (flatten k,v)
      result.merge!(flatten k,v)
    end
    result
  end

private

  def self.flatten k,v
    if v.respond_to? :each
      res = {}
      v.each do |ki, vi|
        res.merge!(flatten "#{k}.#{ki}", vi)
      end
      res
    else
      {k => v}
    end
  end

end
