# Meeting Roulette

A simple Ruby on Rails application for randomly selecting meeting leaders from a group of participants. This tool helps teams fairly distribute meeting leadership responsibilities without bias.

## For Users

### Overview

Meeting Roulette is designed to randomly select a leader for your daily meetings. It helps ensure that everyone gets a chance to lead, keeping meetings fresh and engaging while distributing responsibilities evenly across the team.

### Features

- **Random Selection**: Fairly choose meeting leaders with a spin of the roulette
- **Participant Management**: Add, edit, and remove participants individually
- **Bulk Operations**: Add multiple participants at once and toggle active status in bulk
- **Active/Inactive Status**: Temporarily exclude participants from selection without removing them

### How to Use

1. **Home Screen**: The main page shows the roulette wheel and the number of active participants

2. **Spin the Roulette**: Click the "Spin the Roulette!" button to randomly select a meeting leader

3. **Managing Participants**:

   - Click "Manage Participants" to view, add, edit, or remove participants
   - Use "Add New Participant" to add a single participant
   - Use "Bulk Add Participants" to add multiple people at once (one name per line)
   - Toggle the "Active" status to include/exclude participants from selection
   - Use bulk selection and the "Activate Selected"/"Deactivate Selected" buttons to change multiple statuses at once

### Tips

- Keep the participant list up-to-date as team members join or leave
- If someone is on vacation or unavailable, simply mark them as inactive
- For fairness, avoid manually editing the selection result

## For Developers

### Technical Overview

Meeting Roulette is built with Ruby on Rails and uses a simple SQLite database for storage. The application follows standard Rails MVC architecture.

### Prerequisites

- Ruby 3.2.x or higher
- Rails 7.2.x or higher
- SQLite 3

### Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd meeting_roulette
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   rails db:migrate
   ```

4. Start the server:

   ```bash
   rails server
   ```

5. Access the application at [http://localhost:3000](http://localhost:3000)

### Project Structure

- **Models**: `app/models/participant.rb` - Handles participant data and validation
- **Controllers**:
  - `app/controllers/roulette_controller.rb` - Manages the roulette functionality
  - `app/controllers/participants_controller.rb` - Handles participant CRUD operations
- **Views**:
  - `app/views/roulette/` - Contains the roulette interface
  - `app/views/participants/` - Contains participant management interfaces

### Key Components

#### Participant Model

The `Participant` model includes:

- Name validation
- Active status (defaulted to true)
- Scope for retrieving only active participants

```ruby
# app/models/participant.rb
class Participant < ApplicationRecord
  validates :name, presence: true
  scope :active, -> { where(active: true) }
  
  # Set active to true by default
  after_initialize :set_defaults, if: :new_record?
  
  private
  
  def set_defaults
    self.active = true if self.active.nil?
  end
end
```

#### Roulette Controller

The `RouletteController` handles:

- Displaying the roulette interface
- Randomly selecting a participant
- Rendering the selection result

```ruby
# Key method for random selection
def spin
  active_participants = Participant.active
  
  if active_participants.any?
    # Randomly select one active participant
    @selected = active_participants.offset(rand(active_participants.count)).first
  else
    @selected = nil
  end
  
  render :result
end
```

#### Bulk Operations

The application supports bulk operations through:

- Bulk adding participants (parsing names from a text area)
- Bulk toggling active status (using checkboxes and JavaScript)

### Testing

The application includes a comprehensive test suite:

- **Model Tests**: Test validation and scopes
- **Controller Tests**: Test all controller actions and responses
- **System Tests**: Test the user interface and interactions

Run the tests with:

```bash
rails test                # Run all tests
rails test:models         # Run model tests only
rails test:controllers    # Run controller tests only
rails test:system         # Run system/integration tests
```

### Extending the Application

Some ideas for extending the application:

1. **History Tracking**: Record who was selected and when
2. **Selection Weighting**: Give less weight to recently selected participants
3. **User Authentication**: Add login functionality for different teams
4. **API**: Create an API for integrating with other tools
5. **Slack Integration**: Send results to a Slack channel

## License

This project is open source and available under the [MIT License](LICENSE).
