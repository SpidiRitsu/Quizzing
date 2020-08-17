import {repository} from '@loopback/repository';
import {param, get, getModelSchemaRef} from '@loopback/rest';
import {Notifications, Users} from '../models';
import {NotificationsRepository} from '../repositories';

export class NotificationsUsersController {
  constructor(
    @repository(NotificationsRepository)
    public notificationsRepository: NotificationsRepository,
  ) {}

  @get('/notifications/{id}/users', {
    responses: {
      '200': {
        description: 'Users belonging to Notifications',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(Users)},
          },
        },
      },
    },
  })
  async getUsers(
    @param.path.number('id') id: typeof Notifications.prototype.id,
  ): Promise<Users> {
    return this.notificationsRepository.user(id);
  }
}
