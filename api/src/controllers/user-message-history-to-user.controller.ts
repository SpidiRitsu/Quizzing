import {repository} from '@loopback/repository';
import {param, get, getModelSchemaRef} from '@loopback/rest';
import {UserMessageHistory, Users} from '../models';
import {UserMessageHistoryRepository} from '../repositories';

export class UserMessageHistoryToUserController {
  constructor(
    @repository(UserMessageHistoryRepository)
    public userMessageHistoryRepository: UserMessageHistoryRepository,
  ) {}

  @get('/user-message-histories/{id}/from-users', {
    responses: {
      '200': {
        description: 'Users belonging to UserMessageHistory',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Users)},
          },
        },
      },
    },
  })
  async getUsers(
    @param.path.number('id') id: typeof UserMessageHistory.prototype.id,
  ): Promise<Users> {
    return this.userMessageHistoryRepository.sender(id);
  }
}
