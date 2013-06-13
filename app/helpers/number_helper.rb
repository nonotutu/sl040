#encoding: utf-8

module NumberHelper
  
  
  def to_euro(n)

    if 1 # ( n.is_a?(Integer) || n.is_a?(Float) ) # Uniquement si Integer ou Float
    
      n = n.round(2) # Arrondi à la 2è décimale
      n = n.to_s # Converti en string

      if n.index('.') # Ajout des 0 finaux
        if n.size - n.index('.') == 2
          n += '0'        
        end
      else
        n += '.00'
      end

      d = 0
      if n[0] == '-' # Ajout d'un espace avant le signe négatif
        n.insert(1,' ')
        d = 2
      end

      case (n.index('.') - d ) # Ajout des espaces des milliers
        when 4
          n.insert(1+d,' ')
        when 5
          n.insert(2+d,' ')
        when 6
          n.insert(3+d,' ')
        when 7
          n.insert(4+d,' ')
          n.insert(1+d,' ')
        when 8
          n.insert(5+d,' ')
          n.insert(2+d,' ')
        when 9
          n.insert(6+d,' ')
          n.insert(3+d,' ')
        when 10
          n.insert(7+d,' ')
          n.insert(4+d,' ')
          n.insert(1+d,' ')
      end
        
      n += ' €' # ajout du sigle euro
      n[n.index('.')] = ','
      return n
    end
  end
  
  
  def to_percent(n)
  
    if 1 # n.is_a?(Integer) || n.is_a?(Float) # Uniquement si Integer ou Float

      n = n.round(2) # Arrondi à la 2è décimale
      n = n.to_s # Converti en string

      if n.index('.') # Ajout des 0 finaux
        if n.size - n.index('.') == 2
          n += '0'        
        end
      else
        n += '.00'
      end

      if n[0] == '-' # Ajout d'un espace avant le signe négatif
        n.insert(1,' ')
      end
        
      n += ' %' # ajout du sigle pourcent
      n[n.index('.')] = ','
      return n
    end
  end
  
  
end