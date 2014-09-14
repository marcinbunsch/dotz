Colors = {
  green: '#77c299'
  blue: '#708dbf'
  purple: '#a5547d'
  red: '#e84f5e'
  yellow: '#fece58'
}

# autogenerate names array and count
names = []
for key of Colors
  names.push(key)
Colors.names = names
Colors.count = Colors.names.length

Colors.random = ->
  index = Math.floor(Math.random() * Colors.count)
  name = Colors.names[index]
  Colors[name]

module.exports = Colors

